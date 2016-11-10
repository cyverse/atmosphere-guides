# What is a Boot Script and why would you use it
Boot scripts are a way to dynamically modify the environment of your VM at run time.

Boot scripts can be created for a specific instance
Boot scripts can also be created to execute on a new machine (via Machine Request) for all users who launch that VM.

Boot scripts are executed by the Atmosphere system as the *final* step of the deployment process.

These scripts can be used to:
- execute a daemon/background processes 
- change permissions of a directory to match the active running user, rather than your own account.

These scripts should *NOT* be used to:
- Install new dependencies (Instead, install the software you want and create a Machine Request)

NOTE: A failure of a boot script may cause your VM to behave in an unexpected way, but time will still be counted against you.
      Make sure that you test your boot scripts multiple times before distributing it with your VM.

# Variables that are included in your boot script
- ATMO_USER: This is the username of the account that is running your Image/Instance.

# Examples of a 'Full Text' boot script
A Full text boot script should include a shebang line to tell the bash console what program to use.
The script will be executed directly.

Using the templated variables above can be very helpful for creating dynamic boot scripts.
```
#!/bin/bash -x

# Permissions Granting Script - v1.0
#
# This is a basic 'permissions granting' script to be used as a template
# for image creators, to ensure that their UID is not left on directories
# critical to the success of their image.

main ()
{
    #
    # This is the main function -- These lines will be executed each run
    #

    inject_atmo_vars
    set_directory
}

inject_atmo_vars ()
{
    #
    #
    #NOTE: For now, only $ATMO_USER will be provided to script templates (In addition to the standard 'env')
    #
    #

    # Source the .bashrc -- this contains $ATMO_USER
    PS1='HACK to avoid early-exit in .bashrc'
    . ~/.bashrc
    if [ -z "$ATMO_USER" ]; then
        echo 'Variable $ATMO_USER is not set in .bashrc! Abort!'
        exit 1 # 1 - ATMO_USER is not set!
    fi
    echo "Found user: $ATMO_USER"
}

set_directory ()
{
    # Set directory (via recursive `chown`)
    #TODO: Create a 'chown' line for each directory that should be re-assigned to the current user:
    #
  chown -R $ATMO_USER:iplant-everyone "/opt"
  exit 0
}

# This line will start the execution of the script
main
```

# Examples of a 'URL' boot script
A URL boot script should start with http or https.
A URL boot script should point to the *RAW* file
The file the boot script points to should follow all rules listed in *Examples of a Full Text boot script*
```
https://raw.githubusercontent.com/iPlantCollaborativeOpenSource/atmosphere/master/core/examples/boot_scripts/grant_permissions.sh
```

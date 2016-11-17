# Installation of Atmosphere and Troposphere

### Overview
The installation of Atmosphere and Troposphere can be a complex task when done manually. Fortunately, the team behind the stack has created
a deployment tool that attempts to remove some of the frustrations that one could come across. [Clank](https://github.com/iPlantCollaborativeOpenSource/clank)
is a deployment tool that uses [ansible](https://www.ansible.com/) technology. It deploys the Atmosphere and Troposphere infrastructure within a Linux environment
(perferably Ubuntu) to make using OpenStack fo on-demanding computing needs easy.

#### System Dependencies

Clank perfoms a local install of Atmosphere and Troposphere, and as a result, a few dependencies are required to allow clank to properly run.

The lines below allow clank to run its own series of commands to get ansible to run locally:
```
apt-get install python-virtualenv -y
apt-get install git python-dev libyaml-dev -y
```

Next, create a virtualenv and activate it. This will allow us to keep our python dependencies tidy and in one place without polluting the system.
```
virtualenv ratchet_env
. ratchet_env/bin/activate
```
Once the virtualenv has been created, clone down clank and install its dependencies in our virtualenv.
```
git clone https://github.com/iPlantCollaborativeOpenSource/clank.git
pip install -r clank/ratchet_requirements.txt
```
If you perform a pip freeze, you should see new libraries added.
```
pip freeze
```

#### Requirements for Configuration
A few files are required to be filled out in order for clank to properly function. You can find all the files below in the dist_files directory.

* variables.yml (See [variables dist](https://github.com/iPlantCollaborativeOpenSource/clank/blob/master/dist_files/variables.yml.dist) for blank template)

* hosts (See [hosts dist](https://github.com/iPlantCollaborativeOpenSource/clank/blob/master/dist_files/hosts.dist) for blank template)

* group_vars (See [group_vars dist](https://github.com/iPlantCollaborativeOpenSource/clank/tree/master/dist_files/group_vars) for blank templates)

Your hosts file and group_vars directory should reflect one another. This would include renaming the dist file to relflect the groups you wish to create with ansible.

When you fill out your hosts file and the provider templates in the group_vars directory, be sure to link the location of these files in the variable.yml file.
At the current moment, the only vars that need to be filled in the new variable.yml are:
```
SERVER_URL:                       # myhostname.org

ANSIBLE_HOSTS_FILE:               #Absolute Path Recommended e.g. /path/to/my/hostfile/hosts
ANSIBLE_GROUP_VARS_FOLDER:        #Absolute Path Recommended e.g. /path/to/my/groupvars/dir/group_vars
```

TODO
Condense variables.yml.dist and explain the other vars needed by user (e.g. openstack, ldap, ELK, etc).

#### Installation
Once you have the completed files, its time to run clank! Change directories into the clank repo.
```
cd clank
```
We currently have to pass in two arguments, workspace and env_file. These two variables define the workspace we are working from and the variables.yml file we worked on previously.
If you know the parent directory of the clank directory is, you can pass that, or you can run the command
```
WORKSPACE="$(dirname `pwd`)"
VARIABLES_YML_FILE=/path/to/our/completed/variables.yml
```
And now we run `clank.py` which will install ansible locally, pass in the appropriate variables to ansible, and pass any flags we wish ansible to consume.
```
python clank.py --env_file $VARIABLES_YML_FILE
```

#### Advanced Configuration
##### SSL CERTS
You can have clank install your very own ssl certs, rather than create the self signed certs. To do so, make the changes to your variables.yml file:
```
# SSL RELATED VARS
CREATE_SSL: false                           # Set this to false if you wish to pass in your own certs

# If the above variable is set to true, do not edit next three vars below

SSL_CERTIFICATE: /location/to/my/ssl/cert/we/would/like/to/use/my_cert.crt           #Absolute Path Recommended
BUNDLE_CERT: /location/to/my/ssl/bundle_cert/we/would/like/to/use/my_bundle_cert.crt #Absolute Path Recommended
SSL_KEY: /location/to/my/ssl/private/key/we/would/like/to/use/my_private_key.key     #Absolute Path Recommended
```

##### SSH Keys
You can have clank install your previously created ssh keys of choice, rather than create new ones. To do so, make the changes to your variables.yml file:
```
# SSH KEYS
CREATE_SSH_KEYS: false                     # Set this to false if you wish to pass in your own ssh keys     
ID_RSA:  /location/to/my/id_rsa_key/my_key_id_rsa                      #Absolute Path Recommended
ID_RSA_PUB: /location/to/my/id_rsa_public_key/my_key_id_rsa.pub        #Absolute Path Recommended
```

##### Tags
You are able to isolate which portions of clank you want to run specifically. To do this you can pass in the tags flag to the `clank.py` script:
```
python clank.py --env_file $VARIABLES_YML_FILE --tags atmosphere # Runs only the installation of atmosphere
```
##### Skip
Inversely, you can skip sections:
```
python clank.py --env_file $VARIABLES_YML_FILE --skip atmosphere # skips over the installation of atmosphere
```
```
python clank.py --env_file $VARIABLES_YML_FILE --skip dependencies,troposphere # skips over the installation of dependencies and troposphere
```
## What to do after installing Clank

### Starting the Atmosphere service and logging in

After you have run clank.py successfully, you will need to run:
```
service atmosphere start
```
At which point you should be able to point your browser of choice to `https://<your_server_url>/`. Login (via Mock, CAS, or the AuthenticationBackend you are using) and you should see your username in the top-right corner.
![Troposphere first login](./media/troposphere_first_login.gif)

### Setting your user as staff and superuser
After you have logged in once, you will need to set your user as a staff/superuser.

Because you have to be a superuser in order to access the /admin page for Atmosphere, you will have to do this by the Atmosphere Python REPL:
```
# BASH:
[11:52 root@mickey atmosphere] > cd /opt/dev/atmosphere
[11:52 root@mickey atmosphere] > source /opt/env/atmo/bin/activate
(atmo_ss) [11:52 root@mickey atmosphere] > ./manage.py shell
# In the PYTHON REPL
from core.models import AtmosphereUser
user = AtmosphereUser.objects.get(username='sgregory')
user.is_superuser = True
user.is_staff = True
user.save()
```

### Connecting to a Cloud Provider

Now that you have logged in and marked your user an administrator, you are ready to connect to the cloud. See [Connecting a Cloud Provider](./connecting_cloud_provider.html).

### Creating Accounts using Troposphere
To Add an account with Troposphere, select 'Create New Account' from the 'admin'->'Manage Accounts' tabs in Troposphere.
A modal should appear asking for some information about the user:

#### Describing the 'Create Account' modal:
Atmosphere username - The `username` of the `core.AtmosphereUser` that will be retrieved/created and then assigned to the new identity.
Atmosphere Group Name - The `name` of the `core.Group` that will be retrieved/created (connected to the Atmosphere Username) and then assigned (Membership roles) to the new identity.
Provider - The Cloud Provider you wish to associate the new account with
Quota - The quota you want assigned to your new openstack account (Uses Default Quota by default)
Credentials - A list of key/value pairings that describe your user's openstack account. For a new account
Create a new account - If true, only `key` is required as a credential, password/tenant name will be generated and saved to the identity. If False, all three credentials (key, secret, ex_project_name) are required.
Is this an admin account - If true, (create a new account should be False, here) the account is provisioned differently and then linked to the provider.

Upon creation, Atmosphere will test the identity. If for any reason the identity does *not* produce a valid `rtwo.Driver` the identity will be deleted and an error message will be thrown.

#### Adding the admin account to your new provider
Before you can start adding accounts, you need to designate an identity as "the admin account" for the new provider.
Doing this grants you access to create new accounts, manage users within openstack, as well as monitoring and imaging services through Atmosphere.

After you create the account, you should see it appear in the list of "Identities" just below 'Create New Account' button in Troposphere.

![Troposphere admin account creation](./media/troposphere_create_admin_account.png)

#### Adding a new user account to your new provider
Creating a new account is a simpler process, you can use the description above and the screenshot below to help answer the question of whats required.

Account creation takes a few seconds more than admin account creation (to be sure all of our pieces are properly adjusted).

Upon creation, Atmosphere will test this identity. If for any reason the identity does *not* produce a valid `rtwo.Driver` the identity will be deleted and an error message will be thrown.

After account creation, you should see it appear in the list of "Identities" just below 'Create New Account' button in Troposphere.

![Troposphere user account creation](./media/troposphere_create_user_account.png)

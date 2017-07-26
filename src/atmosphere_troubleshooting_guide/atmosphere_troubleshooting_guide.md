# Atmosphere Troubleshooting Guide

Where to look and what to do when something is broken.

## Common Problems

### My Instance Won't Deploy

Check Atmosphere logs, Kibana, and Celery logs, to determine if the problem is with Atmosphere(2), the OpenStack cloud, or the Ansible code that is run during deployment.

Note that resuming a suspended instance also re-deploys it.

## Troubleshooting Tools

### Launching instances without Troposphere

To launch instances via atmosphere (without the use of a GUI):

```
#############1 - Setting up the environment ######################
# Ensure that PYTHONPATH and DJANGO_SETTINGS_MODULE are pointed to atmosphere:
export PYTHONPATH=/opt/dev/atmosphere:$PYTHONPATH
export DJANGO_SETTINGS_MODULE=atmosphere.settings

#############2 - Getting the correct arguments ######################
# Run script with --provider-list to get providers to launch from:
# ./scripts/launch_instances.py --provider-list
# ID      Name
# 1       EUCALYPTUS
# 2       OPENSTACK
# 3       EC2_US_EAST
# 4       Jetstream - Indiana University
# 5       Jetstream - TACC

# Run script with --provider-id + --size-list and select a size (by ID)
# ./scripts/launch_instances.py --size-list --provider-id 4
# ID      Name    CPU     Memory
# 1       m1.tiny 1       2048
# 2       m1.small        2       4096
# 3       m1.medium       6       16384
# 4       m1.large        10      30720
# 6       m1.xxlarge      44      122880
# 8       m1.xlarge       24      61440
# 30      m1.xlarge.paramtest     24      61440

# Run script with --provider-id + --machine-list and select a machine (by alias)
# ./scripts/launch_instances.py --skip-deploy --users sgregory --size 3 --provider-id 4 --machine-list
# Instances Launched: 235 - 30f31162-2a7a-4ac5-be1a-45c7e579a04b (Provider:4:Jetstream - Indiana University - App:Ubuntu 14.04.3 Development GUI by jfischer - 2017-01-02 18:24:00+00:00 Version:Ubuntu 14.04.3 Development GUI - 1.3 - 2016-07-15 21:02:42.359171+00:00)
# Instances Launched: 156 - 28235434-a4b0-4f27-ad58-e5c3052576da (Provider:4:Jetstream - Indiana University - App:CentOS 6 (6.8) Development GUI by jfischer - 2016-11-04 21:14:02+00:00 Version:CentOS 6 (6.8) Development GUI - 1.5 - 2016-04-01 18:22:33.843209+00:00)
# Instances Launched: 264 - 01fb694b-a58c-46b2-8744-99e177f6ea34 (Provider:4:Jetstream - Indiana University - App:MAKER 2.31.8 with CCTools by upendra - 2017-01-19 18:08:58+00:00 Version:MAKER 2.31.8 with CCTools - 1.0 - END-DATED)
# Instances Launched: 118 - 5ad04c2a-1503-4b44-9f5a-ad0abde2a685 (Provider:4:Jetstream - Indiana University - App:I435-I535-B669 Project B by atmoadmin - 2016-11-11 19:41:09+00:00 Version:I435-I535-B669 Project B - 1.0 - 2016-11-11 15:15:06.345665+00:00)
# Instances Launched: 93 - dbfe6ffa-084f-411d-bde4-676d4ca4da0f (Provider:4:Jetstream - Indiana University - App:CentOS 7 Development by jfischer - END-DATED Version:CentOS 7 Development - 1.1 - END-DATED)
# Instances Launched: 103 - 1c997f2c-bae9-4b53-9197-2948cd449405 (Provider:4:Jetstream - Indiana University - App:Ubuntu 14.04.3 Trusty Tahr by admin - END-DATED Version:Ubuntu 14.04.3 Trusty Tahr - 1.0 - END-DATED)
# Instances Launched: 159 - d1126e09-9e87-4f88-914f-fa42ba256c68 (Provider:4:Jetstream - Indiana University - App:BioLinux 8 by jfischer - 2017-01-24 17:25:40+00:00 Version:BioLinux 8 - 1.0 - 2016-03-29 21:38:14.409121+00:00)
# Instances Launched: 320 - fcc8542f-1b06-4d51-80c9-c8a505bc6eff (Provider:4:Jetstream - Indiana University - App:I535-I435-B669 Project A by luoyu - 2016-10-26 18:08:35+00:00 Version:I535-I435-B669 Project A - 1.0 - 2016-09-21 19:27:05.396602+00:00)
# Instances Launched: 98 - 3c3db94e-377b-4583-83d7-082d1024d74a (Provider:4:Jetstream - Indiana University - App:Ubuntu 14.04.3 Development by jfischer - END-DATED Version:Ubuntu 14.04.3 Development - 1.1 - 2016-05-24 18:00:30.333275+00:00)
# Instances Launched: 152 - bd81558e-9ba9-495e-a82c-4fbfc278a5ee (Provider:4:Jetstream - Indiana University - App:Ubuntu 14.04.3 Development GUI by jfischer - 2017-01-02 18:24:00+00:00 Version:Ubuntu 14.04.3 Development GUI - 1.1-stable - 2016-04-13 17:11:44.783177+00:00)

#############3 - Launching the instance ######################
./scripts/launch_instances.py --users sgregory --size 3 --provider-id 4 --machine-alias 66322719-5bfa-4646-93c6-0132e9a958e5 --name sgregory-testlaunch
Using Username sgregory.
Using Provider 4:Jetstream - Indiana University.
Using Size m1.medium.
.... Logging output for debug purposes
....
Successfully launched Machine 66322719-5bfa-4646-93c6-0132e9a958e5 : 2e90c453-7509-4442-ae28-405b4aaeca10 (Name:sgregory-testlaunch 1, Creator:sgregory, IP:0.0.0.0)
Launched 1 instances.
```

### Launching Instances without atmosphere-ansible

Sometimes it is useful to be able to launch instances, add their floating IP, but **skip the ansible portion** of instance deployment. As it turns out, the script above is perfect for this! simply include the flag `--skip-deploy` to **./scripts/launch_instances.py** in addition to the standard arguments and environment setup described in the section above.

```
#############1 - Setting up the environment ######################
See above
#############2 - Getting the correct arguments ######################
See above
#############3 - Launching the instance ######################
./scripts/launch_instances.py --skip-deploy --users sgregory --size 3 --provider-id 4 --machine-alias 66322719-5bfa-4646-93c6-0132e9a958e5 --name sgregory-test-nodeploy
Using Username sgregory.
Using Provider 4:Jetstream - Indiana University.
Using Size m1.medium.
.... Logging output for debug purposes
....
Successfully launched Machine 66322719-5bfa-4646-93c6-0132e9a958e5 : 2e90c453-7509-4442-ae28-405b4aaeca10 (Name:sgregory-test-nodeploy 1, Creator:sgregory, IP:0.0.0.0)
Launched 1 instances.

## When you decide you would later like to run ansible by hand, via the REPL:
from service.deploy import instance_deploy
instance_deploy(...)
```

### Accessing Atmosphere During Maintenance

There is an "exception" URI to access the UI when Atmosphere is in maintenance mode.

Browse to <a>https://(atmosphere-url)/application_backdoor.</a>

In order to access the backdoor, you will need to be included in [`STAFF_LIST_USERNAMES`](https://github.com/iPlantCollaborativeOpenSource/troposphere/blob/master/troposphere/settings/local.py.j2#L41-L43) . This is set in the variables.yml (build env) for a deployed environment (dev, beta, prod). Using Jinja2 syntax for referring to YAML data structures, within the build env `variables.yml` file, the list is `TROPO['local.py']['STAFF_LIST_USERNAME']`.

Or:

<pre>TROPO:
    local.py:
        STAFF_LIST_USERNAME: ['cmart', 'lenards']</pre>

### Emulating Another Atmosphere(1) User

If you have a staff account in Atmosphere (i.e. you see the "admin" section in Troposphere), you can become ("emulate") another user account. Browse to https://(atmosphere-url)/application/emulate/(username), replacing (atmosphere-url) as appropriate, and (username) with the user you want to emulate. To clear an emulated session, navigate to https://(atmosphere-url)/application/emulate.

### Testing Deployments Against Multiple Distros

See [Images/Accounts to test Ansible](https://pods.iplantcollaborative.org/wiki/display/csmgmt/Ansible+Deployment#AnsibleDeployment-Images/AccountstotestAnsible) (TODO fix link) for a list of images known to work for various distros.

### Capturing Instance Details for Problem Reports

You can easily capture critical information about an instance in order to include it in a problem report. Click on the gravatar (icon), and a string will be printed to your browser's developer tools console in the following format:

```
<image-name> - <instance-GUID> - <provider> - <ip-address> - <deploy-date-time>
```

## Logs

### Log Files on Atmosphere server

Atmosphere(1) writes logs to several places:

- Nginx logs in /var/log/nginx
- uWSGI logs in /var/log/uwsgi/app (atmosphere.log and troposphere.log)
  - "Internal server error" messages usually point to an error here.
- Django logs in /opt/dev/atmosphere/logs
- Celery logs in /var/log/celery
- atmosphere-ansible run logs in /opt/dev/atmosphere/logs/atmosphere_deploy.log

### Celery Flower

[Flower](https://flower.readthedocs.io/en/latest/) is installed for monitoring Celery tasks (e.g. running Ansible against new instances). Browse to https://(atmosphere-url)/flower. The authentication scheme and credentials are set in clank's variables.yml at deploy time.

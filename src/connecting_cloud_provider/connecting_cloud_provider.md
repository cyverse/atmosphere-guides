# Connecting a Cloud Provider to Atmosphere

## Overview
This guide will help you connect Atmosphere to an OpenStack cloud. Atmosphere connects to OpenStack APIs using both LibCloud and the OpenStack client tools.

This is a work in progress, see Chris Martin or Steve Gregory with questions.

## Prerequisites

- Administrative access to an Atmosphere(1) deployment
- Administrative access to an OpenStack deployment configured with:
    - At least one image, size, network, and router ([example directions](https://github.com/cyverse/openstack-ansible-host-prep/blob/master/docs/post-deployment.md))
    - An external network with floating IP addresses available to instances, which are routable at least from your Atmosphere server
- DNS hostname to use for HTTPS connections to your OpenStack APIs, and a client-trusted TLS certificate for this hostname
If you need a certificate, [Let's Encrypt](https://letsencrypt.org/) is your friend
  - Control of a DNS zone that you want to use for instance public IPs (probably optional, can be same zone as above)

Before attempting to connect Atmosphere to your OpenStack cloud, exercise the cloud to confirm basic functionality. Using the Horizon dashboard or OpenStack APIs, verify you can launch an instance, assign a floating IP address, SSH to your instance, create and attach Cinder volumes, and so forth.

## Procedure

### DNS for Instance IP Space

This step is probably optional.

Atmosphere will use a range of DNS names corresponding to your floating IP addresses; the naming convention is configurable when you add the cloud provider below. So, assign hostnames for each of the possible floating IPs in a DNS zone that you control, e.g. vm#.myawesomecloud.org. For example, if your range of available public IPs is 1.2.3.2-62, then create records that resolve vm40.myawesomecloud.org to 1.2.3.40, and so forth throughout the range.

### TLS Certificate for OpenStack API endpoints

Your OpenStack cloud may have its API endpoints configured to use HTTPS with self-signed certificates. These work for testing purposes but are problematic for security; they make it difficult for you to ensure that there is no man-in-the-middle attack between your Atmosphere(1) and your OpenStack cloud. Self-signed certificates encourage you to disable certificate validation in your client applications, which is a **bad** security practice.

So, obtain a TLS/SSL certificate for the hostname you want to use to connect to the OpenStack API. If you don't have one, you can get free certificates from Let's Encrypt; perhaps run it on your load balancer(s) or infrastructure node(s).

Note that the "public" IP address for your OpenStack APIs does not strictly need to be in publicly routable IP space (as long as it is routable from your Atmosphere), but in order to successfully obtain a certificate from Let's Encrypt, you must expose port 80 or 443 on a public IP address from the host making the request.

### OpenStack Configuration

These instructions are written for OpenStack clouds provisioned with the OpenStack-Ansible project (OSA). If you roll your own cloud or get it from elsewhere, you may need to translate, but the concepts still apply. :)

#### Expose APIs and configure HTTPS

Atmosphere(1) needs access to the public API endpoints for the various OpenStack services (which?), and also to the *Keystone admin API*. (Possibly also admin APIs for other services, possibly not?)

These APIs should be configured to use HTTPS only – this is not a strict requirement for testing but should be considered a requirement for any real production deployment, especially if API traffic between Atmosphere(1) and OpenStack will transit networks that you don't trust or control.

By default, OSA configures public API endpoints with HTTPS using self-signed certificates. This is better than no HTTPS at all, but it's much better to use HTTPS real, client-trusted certificates, which we will do.

Also by default, OSA configures the keystone admin API as *non-HTTPS* (plain HTTP), and *only listening on the internal* (container management) network. We need to open this up to listen on a network routable from Atmosphere, and of course, secure the endpoint with HTTPS.

For an OSA deployment, you can configure this in your user_variables.yml as follows:

```
# The following services all need a certificate, private key, and corresponding CA certificate.
# They can all use the same one.
# The paths should point to these files on your OSA deployment host.
# OSA will automatically install them in the appropriate containers.

rabbitmq_user_ssl_cert: /etc/ssl/mycert.crt
rabbitmq_user_ssl_key: /etc/ssl/private/mycert.key
rabbitmq_user_ssl_ca_cert: /etc/ssl/mycert-ca.crt

horizon_user_ssl_cert: /etc/ssl/mycert.crt
horizon_user_ssl_key: /etc/ssl/private/mycert.key
horizon_user_ssl_ca_cert: /etc/ssl/mycert-ca.crt

haproxy_user_ssl_cert: /etc/ssl/mycert.crt
haproxy_user_ssl_key: /etc/ssl/private/mycert.key
haproxy_user_ssl_ca_cert: /etc/ssl/mycert-ca.crt

keystone_user_ssl_cert: /etc/ssl/mycert.crt
keystone_user_ssl_key: /etc/ssl/private/mycert.key
keystone_user_ssl_ca_cert: /etc/ssl/mycert.crt

# HTTPS for keystone admin URI
keystone_service_adminuri_insecure: false
keystone_service_adminuri_proto: https
# Replace myawesomecloud.org with your domain here:
keystone_service_adminuri: "{{ keystone_service_adminuri_proto }}://myawesomecloud.org:{{ keystone_admin_port }}"

# Below is the entire contents of playbooks/vars/configs/haproxy_config.yml.
# I need to copy in the entire dictionary to make small changes, because ansible.cfg has hash_behaviour=replace.
# The ONLY things I'm changing below:
# - the haproxy_whitelist_networks for the keystone_admin service
# - `haproxy_ssl: "{{ haproxy_ssl }}"` for the keystone_admin service

haproxy_default_services:
# (redacting most of haproxy_default_services, it's over 100 lines, but you need to paste the entire dictionary into user_variables.yml in order to override it)
# Make the following modifications to your keystone_admin service:
  - service:
      haproxy_service_name: keystone_admin
      haproxy_backend_nodes: "{{ groups['keystone_all'] | default([])  }}"
      haproxy_port: 35357
      # Add this next line to configure HAProxy to use SSL
      haproxy_ssl: "{{ haproxy_ssl }}"
      haproxy_balance_type: "http"
      haproxy_backend_options:
        - "httpchk HEAD /"
      haproxy_whitelist_networks:
        - 192.168.0.0/16
        - 172.16.0.0/12
        - 10.0.0.0/8
        # Add more networks here, specifically wherever your Atmosphere(1) server lives
        - 128.196.0.0/16
# (redacting the rest of haproxy_default_services)
```

You should also override variables to define your hostname (rather than IP address) for public API endpoints. Note that you may not need all of these if you don't use all the services (but it doesn't hurt). Place these in user_variables.yml, replacing myawesomecloud.org with your actual hostname:

```
glance_service_publicuri: "{{ glance_service_publicuri_proto }}://myawesomecloud.org:{{ glance_service_port }}"
nova_service_publicuri: "{{ nova_service_publicuri_proto }}://myawesomecloud.org:{{ nova_service_port }}"
cinder_service_publicuri: "{{ cinder_service_publicuri_proto }}://myawesomecloud.org:{{ cinder_service_port }}"
keystone_service_publicuri: "{{ keystone_service_publicuri_proto }}://myawesomecloud.org:{{ keystone_service_port }}"
neutron_service_publicuri: "{{ neutron_service_publicuri_proto }}://myawesomecloud.org:{{ neutron_service_port }}"
ceilometer_service_publicuri: "{{ ceilometer_service_proto }}://myawesomecloud.org:{{ ceilometer_service_port }}"
sahara_service_publicuri: "{{ sahara_service_publicuri_proto }}://myawesomecloud.org:{{ sahara_service_port }}"
gnocchi_service_publicurl: "{{ gnocchi_service_publicuri_proto }}://myawesomecloud.org:{{ gnocchi_service_port }}"
aodh_service_publicuri: "{{ aodh_service_proto }}://myawesomecloud.org:{{ aodh_service_port }}"
heat_service_publicuri: "{{ heat_service_publicuri_proto }}://myawesomecloud.org:{{ heat_service_port }}"
heat_cfn_service_publicuri: "{{ heat_cfn_service_publicuri_proto }}://myawesomecloud.org:{{ heat_cfn_service_port }}"
ironic_service_publicuri: "{{ ironic_service_publicuri_proto }}://myawesomecloud.org:{{ ironic_service_port }}"
swift_service_publicuri: "{{ swift_service_publicuri_proto }}://myawesomecloud.org:{{ swift_proxy_port }}"
magnum_service_publicurl: "{{ magnum_service_publicuri_proto }}://myawesomecloud.org:{{ magnum_bind_port }}"
```

(Of course this is Ansible, so you can also declare your hostname as a variable and just use the variable everywhere.)

If you have already deployed your cloud, re-run `setup-infrastructure.yml` and `setup-openstack.yml` to apply your changes.

Finally, check the Keystone service catalog, e.g. from a utility container in an OSA deployment:

```
$ source openrc
$ openstack endpoint list
+----------------------------------+-----------+--------------+----------------+---------+-----------+----------------------------------------------------------------+
| ID                               | Region    | Service Name | Service Type   | Enabled | Interface | URL                                                            |
+----------------------------------+-----------+--------------+----------------+---------+-----------+----------------------------------------------------------------+
# Trimmed internal and most admin APIs for brevity
| 37ceaa7010af4baca7c9ccb6da11eb1b | RegionOne | nova         | compute        | True    | public    | https://myawesomecloud.org:8774/v2.1/%(tenant_id)s             |
| 4b7ded2adbb745d8b71d372466547d9b | RegionOne | keystone     | identity       | True    | public    | https://myawesomecloud.org:5000/v3                             |
| 8555d79a1228407e968a2bd912a2b300 | RegionOne | heat-cfn     | cloudformation | True    | public    | https://myawesomecloud.org:8000/v1                             |
| 92195db12a564a278c3b5482bdf81f35 | RegionOne | heat         | orchestration  | True    | public    | https://myawesomecloud.org:8004/v1/%(tenant_id)s               |
| 98c4284258414220b319607e9049803a | RegionOne | keystone     | identity       | True    | admin     | https://myawesomecloud.org:35357/v3                            |
| c01788fce2574386965beed25ae15e7b | RegionOne | neutron      | network        | True    | public    | https://myawesomecloud.org:9696                                |
| c7887235942a4e75a0c6dc8bab462ff4 | RegionOne | cinder       | volume         | True    | public    | https://myawesomecloud.org:8776/v1/%(tenant_id)s               |
| d0527bc40ea644dbb9f51a9994526904 | RegionOne | cinderv2     | volumev2       | True    | public    | https://myawesomecloud.org:8776/v2/%(tenant_id)s               |
| d39cab53a5d546738aeee36d87115b48 | RegionOne | glance       | image          | True    | public    | https://myawesomecloud.org:9292                                |
+----------------------------------+-----------+--------------+----------------+---------+-----------+----------------------------------------------------------------+
```

You should see HTTPS URLs, with fully qualified domain names (hostnames) instead of IP addresses, for all of the public endpoints, *and also for the keystone admin endpoint*. If so, you're good! (If not, you may need to use `openstack endpoint delete` and `openstack endpoint create` commands to match reality. Don't be afraid to `curl` where you think the endpoints should be, to verify that they are available.)

#### Configure OpenStack for Atmosphere Access

Create a keystone user "atmoadmin", and a project with the same name. Grant the atmoadmin user the "admin" role for the atmoadmin project. (Note that **this gives the atmoadmin user admin rights to the entire OpenStack cloud**.)

To do this in the OpenStack client tools:

```
openstack project create atmoadmin
openstack user create --password mysupersecretpassword --project atmoadmin atmoadmin
openstack role add --user atmoadmin --project atmoadmin admin
```

#### Obtain Credentials

Look for your openrc file, which contains information needed to tell Atmosphere how to connect to OpenStack. If you have Horizon dashboard access, you can download the openrc file specific to a project – browse to Project -> "Access & Security" -> "API Access" -> "Download OpenStack RC File v3". You'll also find openrc files in /root/ in the utility containers that OSA deploys, and in the deployer's home folder on the deployment host.

(CloudLab places this file in `/root/setup/admin-openrc-newcli.sh`, approximately?)

An openrc file will look like this (approximately).

```
export OS_AUTH_URL=https://jetstreamtestcloud.cyverse.org:5000/v3
export OS_PROJECT_ID=090a144b4911402b91fba4ba10c3ebfe
export OS_PROJECT_NAME="cmart"
export OS_USER_DOMAIN_NAME="Default"
if [ -z "$OS_USER_DOMAIN_NAME" ]; then unset OS_USER_DOMAIN_NAME; fi
unset OS_TENANT_ID
unset OS_TENANT_NAME
export OS_USERNAME="admin"
echo "Please enter your OpenStack Password for project $OS_PROJECT_NAME as user $OS_USERNAME: "
read -sr OS_PASSWORD_INPUT
export OS_PASSWORD=$OS_PASSWORD_INPUT
export OS_REGION_NAME="RegionOne"
if [ -z "$OS_REGION_NAME" ]; then unset OS_REGION_NAME; fi
export OS_INTERFACE=public
export OS_IDENTITY_API_VERSION=3
```

### Atmosphere Configuration

#### Add a New Provider

Build some JSON to feed to the add_new_provider.py script. Replace the boilerplate variables here with information from the openrc file and your desired configuration:

```
{
  "admin": {
    "username": "atmoadmin",
    "password": "mysupersecretpassword",
    "tenant": "atmoadmin"
  },
  "credential": {
    "admin_url": "https://myawesomecloud.org:35357",
    "auth_url": "https://myawesomecloud.org:5000",
    "public_routers": "public_router",
    "network_name": "selfservice",
    "region_name": "RegionOne",
    "ex_force_auth_version": "3.x_password"
  },
  "provider": {
    "public": true
  },
  "cloud_config": {
    "network": {
      "dns_nameservers": [
        "8.8.8.8",
        "8.8.4.4"
      ],
      "topology": "External Router Topology"
    },
    "user": {
      "admin_role_name": "admin",  # Matches the admin role in OpenStack
      "user_role_name": "_member_",  # Matches the _member_ role in OpenStack
      "domain": "default",
      "secret": "replacemeplease"  # This will be used to salt the OpenStack passwords for auto-generated user accounts
    },
    "deploy": {
      "hostname_format": "vm%(four)s.mysuperspecialcloud.org"  # Match the hostnames that you configured for instances in DNS above
    }
  }
}
```

On Atmosphere server, pass your JSON file to add_new_provider.py, and answer the prompts: (Don't try add_new_provider.py in fully interactive mode, it's currently broken.)

```
source /opt/env/atmo/bin/activate
cd /opt/dev/atmosphere
export DJANGO_SETTINGS_MODULE='atmosphere.settings'
export PYTHONPATH="$PWD:$PYTHONPATH"
python scripts/add_new_provider.py --from-json /vagrant/my_awesome_cloud.json
What is the name of your new provider?
Name of new provider: my-awesome-cloud
Select a platform type for your new provider
1: KVM (Default), 2: Xen
Select a platform type ([1]/2): 1
What secret would you like to use to create user accounts? (32 character minimum) changeme
What secret would you like to use to create user accounts? (32 character minimum) changeme!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
What is the list of security rules for the provider? (Default: Uses the setting `DEFAULT_RULES`)
default_security_rules for provider: (Should be a list)
1. Provider Information
{'name': 'my-awesome-cloud',
 'platform': <PlatformType: KVM>,
 u'public': True,
 'type': <ProviderType: OpenStack>}
1. Provider Cloud config
{u'deploy': {u'hostname_format': u'vm%(four)s.jetstreamtestcloud.cyverse.org'},
 u'network': {'default_security_rules': [('ICMP', -1, -1),
# Trimmed for brevity
              u'dns_nameservers': [u'8.8.8.8', u'8.8.4.4'],
              u'topology': u'External Router Topology'},
 u'user': {u'admin_role_name': u'admin',
           u'domain': u'default',
           u'secret': 'changeme!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
           u'user_role_name': u'_member_'}}
2. Admin Information
{u'password': u'changeme',
 u'tenant': u'compute',
 u'username': u'admin'}
3. Provider Credentials
{u'admin_url': u'http://10.192.154.100:35357',
 u'auth_url': u'http://10.192.154.100:5000',
 u'ex_force_auth_version': u'3.x_password',
 u'network_name': u'selfservice',
 u'public_routers': u'public_router',
 u'region_name': u'RegionOne'}
Does everything above look correct? [Yes]/No
```

#### Add User Accounts to the new cloud

From the Atmosphere server:
```
source /opt/env/atmo/bin/activate
cd /opt/dev/atmosphere
export DJANGO_SETTINGS_MODULE='atmosphere.settings'
export PYTHONPATH="$PWD:$PYTHONPATH"
# Replace the provider ID to match the provider that you just added
# The first provider added to a new OpenStack deployment is typically 4
python scripts/add_new_accounts.py --provider 4 --users cmart
```

#### Grant Staff/Superuser Privileges

From Atmosphere's manage.py REPL:
```
from core.models import AtmosphereUser
user = AtmosphereUser.objects.get(username="myusername")
user.is_staff = True
user.is_superuser = True
# You must set a password if you are not using an LDAP or mock auth back-end
user.set_password("changeme123")
user.save()
```

If you are not using LDAP or mock authentication, you must also un-comment `django.contrib.auth.backends.ModelBackend` in the `AUTHENTICATION_BACKENDS` section of atmosphere/settings/local.py. (This should be configured by Clank in the future).

#### Choose an Allocation Strategy

From Julian's notes, we should generalize this:

- When you go to URL: <https://youratmosphere.cloud/admin/core/allocationstrategy/>
- And you log in with the staff account that you just configured, or if mock authentication is enabled, any username and any password
    - If you can't log in, make sure that the user is staff and admin: [Make a user staff and admin][]
- Then you should see a heading "Django administration"
- And you should see "Welcome, (yourname)"
- And you should see a title "Select allocation strategy to change"
- When you click on the "Add allocation strategy +" link on the right
- Then you should see a title "Add allocation strategy"
- And the URL should be: "https://youratmosphere.cloud/admin/core/allocationstrategy/add/"
- When you select your new provider from "Provider"
- And you select "1 Month - Calendar Window" from "Counting behavior"
- And you select "First of the Month" from "Refresh behaviors"
- And you select "Ignore non-active status" from "Rules behaviors"
- And you select "Multiply by Size CPU" from "Rules behaviors"
- And you press the "Save" button
- Then you should see: "The allocation strategy \"Provider:4:your-new-cloud Counting:1 Month - Calendar Window Refresh:[<RefreshBehavior: First of the Month>] Rules:[<RulesBehavior: Ignore non-active status>, <RulesBehavior: Multiply by Size CPU>]\" was added successfully."

#### Add OpenStack's Images/Instances/Sizes to Atmosphere

From your Atmosphere server:
```
cd /opt/dev/atmosphere
. /opt/env/atmo/bin/activate
./manage.py shell
# Moving from bash to python repl:
from service.tasks.monitoring import monitor_machines_for, monitor_instances_for, monitor_sizes_for
# Minimally do this once, but each time you change the cloud externally this should also be run
# Replace 8 with your actual provider ID (look it up in the database / Django admin)
monitor_sizes_for(8)
monitor_machines_for(8)
monitor_instances_for(8)  # Only necessary if `nova boot` was done out-of-band
```

#### Update atmosphere-ansible hosts file and group_vars

Ensure that the hostnames of all your VMs are in `/opt/dev/atmosphere-ansible/ansible/hosts`, e.g.:

```
[atmosphere:children]
atmosphere-mytestcloud

[atmosphere-mytestcloud]
vm7.mytestcloud.cyverse.org ansible_host=128.196.171.7 ansible_port=22
```

Also ensure that you have appropriate group_vars defined in `/opt/dev/atmosphere-ansible/ansible/group/vars/name-of-your-cloud`.

#### Test Atmosphere!

In Atmosphere, try logging into the Troposphere UI as the account you added, selecting an image, and launching an instance.

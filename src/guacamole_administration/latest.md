# Guacamole at CyVerse


## Relevant Links
- [Guacamole Administration Atmosphere documentation](https://cyverse.github.io/atmosphere-guides/guacamole_administration.html)
  - this is the documentation for Atmosphere's Guacamole adminstrators
  - it contains some information about the different components, installation, and troubleshooting
  - a lot of the information from this page is duplicated here
- [Atmosphere Guacamole User Guide](https://cyverse.github.io/atmosphere-guides/guacamole_user_guide.html)
  - this is a guide to share with users for more information on using Atmosphere's Web Desktop and Web Shell
- [ansible-guacamole-server](https://github.com/cyverse-ansible/ansible-guacamole-server)
  - probably out of date, should prefer Docker install for future setups
- [guacamole-auth-hmac](https://github.com/cyverse/guacamole-auth-hmac)
  - this is the authentication plugin used for Guacamole auth on Atmosphere
- [guac-cyverse-theme](https://github.com/cyverse/guac-cyverse-theme)
  - this is another plugin that is used to add some CyVerse branding to Guacamole. It also adds some additional help text for users and disables the Guacamole login page
- [Guacamole `docker-compose` example in `atmosphere-docker`](https://github.com/cyverse/atmosphere-docker/blob/master/docker-compose.guac.yml)
  - this can be used as an example for future Guacamole docker deployments


## Authentication and Relationship with Atmosphere
Additional documentation is provided in the repositories mentioned above. 

### Troposphere
Relevant Troposphere code can be found here:
- [JavaScript UI](https://github.com/cyverse/troposphere/blob/1f98da2373bd0e4c93f03b6fc060a0544933404f/troposphere/static/js/components/projects/resources/instance/details/actions/InstanceActionsAndLinks.jsx#L191-L237)
- [Django Python API](https://github.com/cyverse/troposphere/blob/master/troposphere/views/web_desktop.py#L15-L69)
    
The Django Python API part will just make a request to the Atmosphere backend and redirect to the Web Desktop page.

### Atmosphere
Relevant Atmosphere code can be found [here](https://github.com/cyverse/atmosphere/blob/master/api/v2/views/web_token.py)

In this file, the `guacamole_token` function is the most important since it uses the HMAC method to create and verify a signature and generate the URL for the instance's connection. The fields used here allow us to configure specific connection parameters.

### Atmosphere-Ansible
Relevant Atmosphere-Ansible can be found here:
- [Playbook for VNC](https://github.com/cyverse/atmosphere-ansible/blob/master/ansible/playbooks/instance_deploy/30_post_user_install.yml#L10)
- [Tasks for Guacamole VNC](https://github.com/cyverse/atmosphere-ansible/blob/master/ansible/roles/atmo-vnc/tasks/guacamole.yml)
  - This task will configure the Guacamole-specific settings for the VNC Server
  - These settings specify that this instance of the server can only be access from the Guacamole server's IP address
  - Runs on port `5905`
- [Playbook for SSH/WebShell](https://github.com/cyverse/atmosphere-ansible/blob/master/ansible/playbooks/instance_deploy/41_shell_access.yml)
- [Role for SSH/WebShell](https://github.com/cyverse/atmosphere-ansible/tree/master/ansible/roles/sshkey-host-access)
  - Since Guacamole will need a keypair to connect the the instance's SSH server, atmosphere-ansible will connect to the Guacamole server and create a keypair (if it does not exist) and save it on the server
  - The public key is added to the instance's `authorized_keys`
  - The HMAC auth plugin will then read from the filesystem on the Guacamole server to find the private key necessary for SSH access when initiating a connection


## Installation/Setup
As mentioned above, there is an ansible role and playbook for setting up the server, but this is pretty out-of-date and the preferred method for future deployments should be using `docker-compose`. An example of this can be found in the `atmosphere-docker` repository:
  - [`docker-compose` file](https://github.com/cyverse/atmosphere-docker/blob/master/docker-compose.guac.yml)
  - [directory with additional files/configurations](https://github.com/cyverse/atmosphere-docker/tree/master/guacamole)

Basically, this will consist of two containers: `guacd` and `guacamole` webapp. Depending on setup, there could also be an Nginx container or non-containerized Nginx with [this configuration](https://github.com/CyVerse-Ansible/ansible-guacamole-server/blob/master/templates/nginx-guacamole.conf.j2).

The `guacamole` webapp container will need a volume mount to give it access to a `guacamole.properties` file and an `extensions` directory containing JAR files for the theme and auth plugins. This volume or a separate volume should mount the user SSH keys (to the path specified in `guacamole.properties`).

Instructions for creating the JAR files can be found in the READMEs of each plugin repository.


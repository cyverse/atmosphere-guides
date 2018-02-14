# Guacamole Installation at CyVerse

This guide will help you to understand and re-create the installation of [Apache Guacamole](https://guacamole.apache.org/) at CyVerse. See Apache's official [install guide](https://guacamole.apache.org/doc/gug/installing-guacamole.html) and [configuration guide](https://guacamole.apache.org/doc/gug/configuring-guacamole.html).

## CyVerse Guacamole repositories

- Ansible for deploying Guacamole can be found here: https://github.com/CyVerse-Ansible/ansible-guacamole-server
- Guacamole HMAC Authentication extension: https://github.com/calvinmclean/guacamole-auth-hmac
- Guacamole CyVerse theming: https://github.com/calvinmclean/guac-cyverse-theme


## Things to know

Guacamole webapp is located at `/var/lib/tomcat7/webapps/guacamole.war`.

Guacamole configuration files are located in `/usr/share/tomcat7/.guacamole` which is linked to `/etc/guacamole`. Extensions (hmac auth, CyVerse theme), are located in the subdirectory `extensions`.

Guacamole is proxied through Nginx with the config file in `/etc/nginx/sites-available/nginx-guacamole.conf`.

An up-to-date `cyverse-theme.jar` is included in the ansible role and is installed in `/etc/guacamole/extensions`. If you need to manually update the extension, create the jar by zipping the extensions contents, not the directory: `zip -r theme.jar *`. For Jetstream, checkout the 'jetstream' branch and create the jar.


## Before running the Ansible role

- Define necessary variables
- The variable `nginx_gauc_loc` is "/guacamole" by default, but our production server uses "" so Guacamole can be found on guacamole-prod.cyverse.org/ (instead of guacamole-prod.cyverse.org/guacamole).
- `install_type` is used to specify if you are installing for CyVerse or Jetstream. It just changes which theme extension is used.
- Add host to your hosts file:

```yaml
[guac-servers]
guac-prod ansible_host=guac.cyverse.org
guac-jetstream ansible_host=guac.jetstream-cloud.org
guac-test ansible_host=192.168.0.111
```


## Running the Ansible role

- Create playbook. Example:

```yaml
- hosts: guac-servers
  remote_user: root
  vars:
    letsencrypt_renew_email: "me@cyverse.org"
    nginx_gauc_loc: ""

  roles:
    - ansible-guacamole-server
```

- Run the playbook:

```bash
ansible-playbook guac-pb.yml -l guac-test
```

## After deploying Guacamole with the Ansible role

- Ensure that Let's Encrypt certificates are successfully setup, fix them if needed.
- Double check that `/etc/guacamole` is owned by `tomcat7:tomcat7`

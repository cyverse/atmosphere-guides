# Guacamole Installation at CyVerse

This guide will help you to understand and re-create the installation of [Apache Guacamole](https://guacamole.apache.org/) at CyVerse. See Apache's official [install guide](https://guacamole.apache.org/doc/gug/installing-guacamole.html) and [configuration guide](https://guacamole.apache.org/doc/gug/configuring-guacamole.html).


## Things to know

Guacamole webapp is located at `/var/lib/tomcat7/webapps/guacamole.war`.

Guacamole configuration files are located in `/usr/share/tomcat7/.guacamole` which is linked to `/etc/guacamole`. Extensions (hmac auth, CyVerse theme), are located in the subdirectory `extensions`.

Guacamole is proxied through Nginx with the config file in `/etc/nginx/sites-available/nginx-guacamole.conf`.

Create the `cyverse-theme.jar` file by zipping the extensions contents, not the directory: `zip -r theme.jar *`. For Jetstream, checkout the 'jetstream' branch and create the jar.

`guacd` logs can be found in `/var/log/syslog`

tomcat logs can be found at `/var/log/tomcat7/catalina.out`. Some additional logging may be at `/var/log/tomcat7/localhost.out`


## Step-by-step

1. Follow the [official documentation](https://guacamole.apache.org/doc/gug/installing-guacamole.html) to setup Guacamole webapp and `guacd` daemon. Use the default `/usr/share/tomcat7/.guacamole` `GUACAMOLE_HOME` linked to `/etc/guacamole/`

2. Get the [`guacamole-auth-hmac`](https://github.com/cyverse/guacamole-auth-hmac) jar file by either downloading from the [releases page](https://github.com/cyverse/guacamole-auth-hmac/releases) or [building from source](https://github.com/cyverse/guacamole-auth-hmac#building) and put it in `/etc/guacamole/extensions/`

3. Get the [`guac-cyverse-theme`](https://github.com/cyverse/guac-cyverse-theme) jar file by either downloading from the [releases page](https://github.com/cyverse/guac-cyverse-theme/releases) or [building from source](https://github.com/cyverse/guac-cyverse-theme#instructions) and put it in `/etc/guacamole/extensions/`

4. Create `/etc/guacamole/keys` directory and make sure it is owned by the system's tomcat user

5. Make sure `/etc/guacamole/guacamole.properties` looks something like this:
    ```
    guacd-hostname: localhost
    guacd-port: 4822
    guacd-ssl: False
    secret-key: <secret_from_atmosphere_secrets>
    timestamp-age-limit: 600000
    use-local-privkey: True
    key-directory: /etc/guacamole/keys/
    ```

6. Configure Nginx:
    ```
    ## location: /etc/nginx/sites-available
    ## link to sites-enabled: ln -s /etc/nginx/sites-enabled/nginx-guacamole /etc/nginx/sites-available/nginx-guacamole

    server {
      listen 80;
      return 301 https://$host$request_uri;
    }

    server {
      listen 443;

      root /var/lib/tomcat7/webapps/guacamole;

      server_name {{ SERVER_ADDRESS }};

      ssl_certificate           /{{ SSL_DIRECTORY }}/fullchain.pem;
      ssl_certificate_key       /{{ SSL_DIRECTORY }}/privkey.pem;

      ssl on;
      ssl_session_cache  builtin:1000  shared:SSL:10m;
      ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
      ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;
      ssl_prefer_server_ciphers on;

      location / {
        proxy_pass http://localhost:8080/guacamole/;
        proxy_buffering off;
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $http_connection;
        access_log off;
      }
    }
    ```

7. Restart services
    ```
    systemctl restart tomcat7
    systemctl restart guacd
    systemctl restart nginx
    ```

8. In order to connect with Atmosphere, make sure to fill out the following variables in `atmosphere-docker-secrets`:
    - `inis/atmosphere.ini`:
      ```ini
      GUACAMOLE_ENABLED = True
      GUACAMOLE_SECRET_KEY = "big-secret"
      GUACAMOLE_SERVER_URL = "https://guacamole-prod.cyverse.org/"
      ```
    - `inis/troposphere.ini`:
      ```ini
      GUACAMOLE_ENABLED = True
      ```
    - `atmosphere-ansible/hosts`:
      ```
      guac_server ansible_host=<ip_or_domain> ansible_port=<port>
      ```
    - `atmosphere-ansible/group_vars/all`:
      ```yaml
      SETUP_GUACAMOLE: true
      GUACAMOLE_SERVER_IP: <ip_address>
      ```


### Note
Additional information can be gathered from this ansible repository:

https://github.com/CyVerse-Ansible/ansible-guacamole-server

However, it may not be completely up-to-date


### Notes for future Docker setup
As mentioned above, there is an ansible role and playbook for setting up the server, but this is pretty out-of-date and the preferred method for future deployments should be using `docker-compose`. An example of this can be found in the `atmosphere-docker` repository:
  - [`docker-compose` file](https://github.com/cyverse/atmosphere-docker/blob/master/docker-compose.guac.yml)
  - [directory with additional files/configurations](https://github.com/cyverse/atmosphere-docker/tree/master/guacamole)

Basically, this will consist of two containers: `guacd` and `guacamole` webapp. Depending on setup, there could also be an Nginx container or non-containerized Nginx with [this configuration](https://github.com/CyVerse-Ansible/ansible-guacamole-server/blob/master/templates/nginx-guacamole.conf.j2).

The `guacamole` webapp container will need a volume mount to give it access to a `guacamole.properties` file and an `extensions` directory containing JAR files for the theme and auth plugins. This volume or a separate volume should mount the user SSH keys (to the path specified in `guacamole.properties`).

Instructions for creating the JAR files can be found in the READMEs of each plugin repository.

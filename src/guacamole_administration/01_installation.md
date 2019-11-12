# Guacamole Installation at CyVerse

This guide will help you to understand and re-create the installation of [Apache Guacamole](https://guacamole.apache.org/) at CyVerse. See Apache's official [install guide](https://guacamole.apache.org/doc/gug/installing-guacamole.html) and [configuration guide](https://guacamole.apache.org/doc/gug/configuring-guacamole.html).

## CyVerse Guacamole repositories

- Guacamole HMAC Authentication extension: https://github.com/cyverse/guacamole-auth-hmac
- Guacamole CyVerse theming: https://github.com/cyverse/guac-cyverse-theme


## Things to know

Guacamole webapp is located at `/var/lib/tomcat7/webapps/guacamole.war`.

Guacamole configuration files are located in `/usr/share/tomcat7/.guacamole` which is linked to `/etc/guacamole`. Extensions (hmac auth, CyVerse theme), are located in the subdirectory `extensions`.

Guacamole is proxied through Nginx with the config file in `/etc/nginx/sites-available/nginx-guacamole.conf`.

Create the `cyverse-theme.jar` file by zipping the extensions contents, not the directory: `zip -r theme.jar *`. For Jetstream, checkout the 'jetstream' branch and create the jar.

`guacd` logs can be found in `/var/log/syslog`

tomcat logs can be found at `/var/log/tomcat7/catalina.out`. Some additional logging may be at `/var/log/tomcat7/localhost.out`


## Step-by-step

1. Follow the [official documentation](https://guacamole.apache.org/doc/gug/installing-guacamole.html) to setup Guacamole webapp and `guacd` daemon. Use the default `/usr/share/tomcat7/.guacamole` GUACAMOLE_HOME linked to `/etc/guacamole/`

2. Clone the [`guacamole-auth-hmac` extension repository](https://github.com/cyverse/guacamole-auth-hmac)
  1. Compile with `mvn package`
  2. Copy to Guacamole extensions directory:
    ```
    cp target/guacamole-auth-hmac-<version>.jar /etc/guacamole/extensions/
    ```

3. Clone the [`guac-cyverse-theme` extension repository](https://github.com/cyverse/guac-cyverse-theme)
  1. For CyVerse, use `master` branch. For Jetstream, use `jetstream` branch
  2. From inside the directory, zip up the files:
    ```
    zip -r theme.jar *
    ```
  3. Copy to Guacamole extensions directory:
    ```
    cp theme.jar /etc/guacamole/extensions
    ```

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

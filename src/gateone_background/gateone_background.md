# GateOne Background

## What is GateOne?

It's a web shell, aka terminal, emulator & SSH client that uses HTML5 technologies.
- another way to put it, it uses pure HTML, JavaScript and web sockets

The underlying technologies?
- Python + Tornado web server
- JavaScript
- nginx

## How do we use it?

We offer a web shell to instances in the cloud via GateOne. It appears as a
view within Django [0] - the resources of GateOne as "included" and render as
*embedded*. This impacts _how_ the associated GateOne resources are served; if
they're served from a domain different from Troposphere - then Cross-Origin
Resource Sharing (CORS) would be happening [1]

## How does it know we are a valid request origin?

There are two aspects required here:

1. An API key and secret that both Troposphere & GateOne know _about_
2. A white-list of valid *origins*

### Key/Secret

GateOne has an Authenticated API [2]. You generate an API key and secret [3],
then use them to create an HMAC signature of the required authentication info:

```
authobj = {
  'api_key': 'MjkwYzc3MDI2MjhhNGZkNDg1MjJkODgyYjBmN2MyMTM4M',
  'upn': 'joe@company.com',
  'timestamp': '1323391717238',
  'signature': "f6c6c82281f8d56797599aeee01a5e3efab05a63",
  'signature_method': 'HMAC-SHA1',
  'api_version': '1.0'
}
```

source: [https://liftoff.github.io/GateOne/Developer/embedding_api_auth.html#generate-an-auth-object](https://liftoff.github.io/GateOne/Developer/embedding_api_auth.html#generate-an-auth-object)

You can find this key and secret within the GateOne configration file `30api_keys.conf` [4]

Note, the `upn` value was what previous prevented us from _emulating_ a user.

### Origin

The allowed `origins` is a JSON array of either hostname or IP that are accepted.

`origins` appears in the `10server.conf` file [5]

```
// This is Gate One's main settings file.
{
  // "gateone" server-wide settings fall under "*"
  "*": {
    "gateone": { // These settings apply to all of Gate One
        //
        // ... omit ...
        //
        "origins": [
        "localhost", "127.0.0.1", "enterprise",
        "enterprise.example.com", "10.1.1.100"],
        //
        // ... omit ...
        //
    }
  }
}
```

Note, all configuration for deployed GateOne servers appears under: `/etc/gateone/conf.d`

These are symlinks into the `/opt/gateone-config` directory.

## How is GateOne Deployed?

For Atmosphere(0) and Jetstream Cloud, GateOne and Atmosphere(1) are implemented on separate servers. (This may not be a strict requirement.)

### Ansible

There are currently two different sets of Ansible code that deploy GateOne.

#### [https://github.com/cyverse/gateone-server-ansible](https://github.com/cyverse/gateone-server-ansible)

gateone-server-ansible was used to implement Jetstream Cloud's production GateOne. It has a few requirements:

* requires you to symlink to /etc/ansible/roles
* Assumes that SSL certificate and private key are already deployed to target server
* requires you to store your GateOne configuration in a separate repository

#### [https://github.com/cyverse-ansible/ansible-gateone-server](https://github.com/cyverse-ansible/ansible-gateone-server)

ansible-gateone-server is a newer, modular Ansible role that is published on (and consumable from) Ansible Galaxy. It is used to implement GateOne for the Jetstream test cloud. ansible-gateone-server is self-contained: it does not require separate repos for your GateOne configuration files, instead you can define your configuration as Ansible variables. ansible-gateone-server will also deploy your SSL certificate and private key - in this way, it is a "batteries-included" way to implement a working GateOne on a brand new server.

### Customizations

We currently operate off of a fork of GateOne:

[https://github.com/edwins/GateOne](https://github.com/edwins/GateOne)

This is fork includes added functionality for having a "global" SSH config file. This file appears as a symlink under `/etc/gateone/conf.d` and links to: `/opt/gateone-config/ssh_config_global`. Efforts to get this modification included by the GateOne project are underway.

Both of the Ansible options deploy this fork of GateOne, by default.

## Troubleshooting Background

### Resource Serving

We currently put Nginx in front of GateOne. GateOne serves resources via an Nginx
location defined in under `/etc/nginx/locations`

```
location /gateone {
  #Listed as /gateone
  proxy_pass_header Server;
  proxy_set_header Host $http_host;
  proxy_redirect off;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Scheme $scheme;
  proxy_pass https://atmo-proxy.example.org:8443;
  proxy_http_version 1.1;
  // these be web socket headers ---v
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection "upgrade";
}
```

Note: the "Connection" header is present to allow for Web Socket connections

### Service Operation

You can verify that GateOne is running using `service`:

```
$ service gateone status
gateone start/running, process 12634</pre>
```

If the service fails to start, the init system (currently upstart) will try restarting the service several times and then give up. You can try starting GateOne outside of the service – and watch the output yourself -- by running `/usr/bin/python /usr/local/bin/gateone`. This may provide helpful information in addition to the logs.

Because Nginx makes GateOne available to the outside world, you'd want to
ensure that it was running as well:

```
service nginx status
nginx start/running, process 8818
```

### Ports

Ensure that GateOne is bound to the internal port for reverse proxying (e.g. 8443) and that Nginx is listening on the HTTPS port (e.g. 443):

```
root@myserver:/etc/gateone/conf.d# netstat -lntp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:111             0.0.0.0:*               LISTEN      9089/rpcbind    
tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN      5634/sendmail: MTA:
tcp        0      0 0.0.0.0:1657            0.0.0.0:*               LISTEN      2567/sshd       
tcp        0      0 0.0.0.0:8443            0.0.0.0:*               LISTEN      8821/python # GateOne!    
tcp        0      0 0.0.0.0:443             0.0.0.0:*               LISTEN      28230/nginx # Nginx proxy for GateOne
tcp        0      0 0.0.0.0:5666            0.0.0.0:*               LISTEN      10622/nrpe      
tcp        0      0 127.0.0.1:587           0.0.0.0:*               LISTEN      5634/sendmail: MTA:
tcp6       0      0 :::111                  :::*                    LISTEN      9089/rpcbind    
tcp6       0      0 :::1657                 :::*                    LISTEN      2567/sshd       
tcp6       0      0 :::8443                 :::*                    LISTEN      8821/python     
tcp6       0      0 :::5666                 :::*                    LISTEN      10622/nrpe
```

Also ensure that communications are not blocked by ufw/iptables/firewalld on the host, nor by a border firewall on the hosting facility / campus network.

### Logs

All logs associated with GateOne are under `/var/log/gateone/`

You can change the logging level in `/etc/gateone/conf.d/10server.conf`

```
// This is Gate One's main settings file.
{
    // "gateone" server-wide settings fall under "*"
    "*": {
        "gateone": { // These settings apply to all of Gate One
            "logging": "info",

			// ....
```

With a logging level of "info", changes to the "origins" will be logged to `/var/log/gateone/gateone-api.log`

```
[I 161004 13:18:48 server:4361] Connections to this server will be allowed from the following origins: 'localhost 127.0.0.1 ...'
[I 161004 13:18:48 server:3675] Using api authentication
```

With a logging level of "info", authentication attempts (including the "origin") will be logged to `/var/log/gateone/gateone-auth.log`

```
[I 160502 13:50:04 server:2223] User lenards authenticated successfully via origin atmobeta.myexample.org (location 128-196-65-166).
[I 160502 13:53:14 server:1765] {"ip_address": "127.0.0.1", "location": "128-196-65-166", "upn": "lenards"} WebSocket closed (lenards 127.0.0.1).
```

You'd also want to investigate nginx's logs as well (`/var/log/nginx`), notably the error.log.

### Keys & connecting the dots...

Atmosphere generates a default SSH key per user and places this key on the
GateOne server. It is used for password-less connections to instances. When
an instance is launched, this default key will be included.

If you're troubleshooting, you may want to look for the presence of a key. You
can find them under `/var/lib/gateone/{{atmosphere_username}}/.ssh`.

### dtach

This process helps preserve the state of a GateOne session (it appears as `dtach` in `ps aux`)

[https://github.com/bogner/dtach](https://github.com/bogner/dtach)

You can look for a user's session by IP:

```
# ps aux | grep dtach | grep '128-196-64-13'
root 6509 0.0 0.0 4400 608 pts/33 Ss+ Oct03 0:00 /bin/sh -c dtach -c /tmp/gateone-api/MmFjYmU5OTgzZTJiNGY0ZjliNjg4OTZkYTNiY2MxNzQ0Z/dtach_128-196-64-13_1 -E -z -r none /usr/local/lib/python2.7/dist-packages/gateone-1.2.0-py2.7.egg/gateone/applications/terminal/plugins/ssh/scripts/ssh_connect.py -S '/tmp/gateone-api/MmFjYmU5OTgzZTJiNGY0ZjliNjg4OTZkYTNiY2MxNzQ0Z/%SHORT_SOCKET%' --sshfp --config '/etc/gateone/conf.d/ssh_config_global'; sleep .1
root 6512 0.0 0.0 6228 360 pts/33 S+ Oct03 0:00 dtach -c /tmp/gateone-api/MmFjYmU5OTgzZTJiNGY0ZjliNjg4OTZkYTNiY2MxNzQ0Z/dtach_128-196-64-13_1 -E -z -r none /usr/local/lib/python2.7/dist-packages/gateone-1.2.0-py2.7.egg/gateone/applications/terminal/plugins/ssh/scripts/ssh_connect.py -S /tmp/gateone-api/MmFjYmU5OTgzZTJiNGY0ZjliNjg4OTZkYTNiY2MxNzQ0Z/%SHORT_SOCKET% --sshfp --config /etc/gateone/conf.d/ssh_config_global
root 6513 0.0 0.0 14792 704 ? Ss Oct03 0:00 dtach -c /tmp/gateone-api/MmFjYmU5OTgzZTJiNGY0ZjliNjg4OTZkYTNiY2MxNzQ0Z/dtach_128-196-64-13_1 -E -z -r none /usr/local/lib/python2.7/dist-packages/gateone-1.2.0-py2.7.egg/gateone/applications/terminal/plugins/ssh/scripts/ssh_connect.py -S /tmp/gateone-api/MmFjYmU5OTgzZTJiNGY0ZjliNjg4OTZkYTNiY2MxNzQ0Z/%SHORT_SOCKET% --sshfp --config /etc/gateone/conf.d/ssh_config_global
root 27455 0.0 0.0 4400 612 pts/14 Ss+ Oct03 0:00 /bin/sh -c dtach -c /tmp/gateone-api/MzAwMzZhNGNhYjJjNGRhZWEyNzU5ZWVkMjBkYWY0ZjBlZ/dtach_128-196-64-13_1 -E -z -r none /usr/local/lib/python2.7/dist-packages/gateone-1.2.0-py2.7.egg/gateone/applications/terminal/plugins/ssh/scripts/ssh_connect.py -S '/tmp/gateone-api/MzAwMzZhNGNhYjJjNGRhZWEyNzU5ZWVkMjBkYWY0ZjBlZ/%SHORT_SOCKET%' --sshfp --config '/etc/gateone/conf.d/ssh_config_global'; sleep .1
root 27456 0.0 0.0 6228 364 pts/14 S+ Oct03 0:00 dtach -c /tmp/gateone-api/MzAwMzZhNGNhYjJjNGRhZWEyNzU5ZWVkMjBkYWY0ZjBlZ/dtach_128-196-64-13_1 -E -z -r none /usr/local/lib/python2.7/dist-packages/gateone-1.2.0-py2.7.egg/gateone/applications/terminal/plugins/ssh/scripts/ssh_connect.py -S /tmp/gateone-api/MzAwMzZhNGNhYjJjNGRhZWEyNzU5ZWVkMjBkYWY0ZjBlZ/%SHORT_SOCKET% --sshfp --config /etc/gateone/conf.d/ssh_config_global
root 27457 0.0 0.0 14792 708 ? Ss Oct03 0:00 dtach -c /tmp/gateone-api/MzAwMzZhNGNhYjJjNGRhZWEyNzU5ZWVkMjBkYWY0ZjBlZ/dtach_128-196-64-13_1 -E -z -r none /usr/local/lib/python2.7/dist-packages/gateone-1.2.0-py2.7.egg/gateone/applications/terminal/plugins/ssh/scripts/ssh_connect.py -S /tmp/gateone-api/MzAwMzZhNGNhYjJjNGRhZWEyNzU5ZWVkMjBkYWY0ZjBlZ/%SHORT_SOCKET% --sshfp --config /etc/gateone/conf.d/ssh_config_global
```

## Troubleshooting Specifics

### Welcome to nginx "page"

This is a misconfigured deployment of Troposphere

### Troposphere "source" not in `origins`

Click to accept SSL Certificate ...

White screen with black background messages

### GateOne is not defined

This means that either the GateOne service is down or not responding.

## Generating a new API key & secret

The documentation of GateOne still refers to the utility executable as `./gateone.py`. It is is `./run_gateone.py` (in [our fork](https://github.com/edwins/GateOne/), and in [master](https://github.com/liftoff/GateOne/tree/master)).

```
# python run_gateone.py --help
Usage: run_gateone.py [OPTIONS]
```

From the code-base location, you can run `run_gateone.py` with `--new_api_key` to get a new API key.

Because we use a custom "settings_dir", you **must** include the path to that location or it will use `/opt/GateOne/conf.d` as the location of where the secret is written

```
/opt/GateOne$ ./run_gateone.py --new_api_key --settings_dir=/etc/gateone/conf.d/
[I 161004 13:42:24 server:4179] Gate One License: AGPLv3 (http://www.gnu.org/licenses/agpl-3.0.html)
[I 161004 13:42:24 server:4188] Imported applications: Terminal
[I 161004 13:42:24 server:4323] A new API key has been generated: [redacted]
[I 161004 13:42:24 server:4325] This key can now be used to embed Gate One into other applications.
/opt/GateOne$ grep -c "[redacted]" /etc/gateone/conf.d/30api_keys.conf && echo "sssh ... it is still secret"
1
sssh ... it is still secret
```

The secret will be added to /etc/gateone/conf.d/30api_keys.conf

```
{
    "*": {
        "gateone": {
            "api_keys": {
                "<API Key>": "<Secret>",
                "<API Key 2>": "<Secret 2>"
            }
        }
    }
}
```

## References

- 0 [https://github.com/iPlantCollaborativeOpenSource/troposphere/blob/master/troposphere/views/web_shell.py](https://github.com/iPlantCollaborativeOpenSource/troposphere/blob/master/troposphere/views/web_shell.py)
- 1 [https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS)
- 2 [https://liftoff.github.io/GateOne/Developer/embedding_api_auth.html](https://liftoff.github.io/GateOne/Developer/embedding_api_auth.html)
- 3 [https://liftoff.github.io/GateOne/Developer/embedding_api_auth.html#generate-an-api-key-secret](https://liftoff.github.io/GateOne/Developer/embedding_api_auth.html#generate-an-api-key-secret)
- 4 below *note*, [https://liftoff.github.io/GateOne/Developer/embedding_api_auth.html#generate-an-api-key-secret](https://liftoff.github.io/GateOne/Developer/embedding_api_auth.html#generate-an-api-key-secret)
- 5 [https://liftoff.github.io/GateOne/About/configuration.html](https://liftoff.github.io/GateOne/About/configuration.html)

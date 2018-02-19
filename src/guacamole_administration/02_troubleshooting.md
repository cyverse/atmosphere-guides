# Troubleshooting Guacamole

These are a few common problems we see with Guacamole on Atmosphere. See Apache Guacamole's [troubleshooting guide](https://guacamole.apache.org/doc/gug/troubleshooting.html) for additional troubleshooting help.

## Assisting Users

Tips for troubleshooting problems that users experience.

### Problem: "Connection Error - closed the connection" when attempting a connection.
The user was successfully authenticated by the Guacamole server, but the Guacamole server could not connect to the instance. Therefore, this is most likely a problem with the instance, not the server.

##### Solution
If it is a VNC connection, the instance's VNC server is messed up. To fix it:
```bash
# Kill the Guacamole-specific VNC server
# If you get an error, that means the server is already killed
vncserver -kill :5

# Restart the VNC server
vncserver -config ~/.vnc/config.guac :5
```


## Server-side Troubleshooting

Tips for troubleshooting issues on the Guacamole server.

### Problem: "Unable to bind socket to any addresses." error from guacd
This error may appear in the syslog when trying to restart the guacd process. This error occurs when you try to start guacd while it is already running.

##### Solution:
Manually kill the guacd process.
```bash
pkill -f guacd
```

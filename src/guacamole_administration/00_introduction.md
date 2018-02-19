# Guacamole Introduction

[Apache Guacamole](https://guacamole.apache.org/) is a clientless remote access gateway. At CyVerse, we use it to provide web-based VNC and SSH connections to user instances.


## Components

The Guacamole setup at CyVerse consists of a few components:

1. Tomcat7 Java web-servlet to run the webapp (Within the webapp, there is an authentication plugin and a theming plugin)

1. Nginx reverse proxy with SSL

1. guacd is the daemon that handles Guacamole operations. Here is a description from [Guacamole's documentation](http://guacamole.apache.org/doc/gug/guacamole-architecture.html#guacd):

    > guacd is a daemon process which is installed along with Guacamole and runs in the background, listening for TCP connections from the web application. guacd also does not understand any specific remote desktop protocol, but rather implements just enough of the Guacamole protocol to determine which protocol support needs to be loaded and what arguments must be passed to it. Once a client plugin is loaded, it runs independently of guacd and has full control of the communication between itself and the web application until the client plugin terminates.




## Authentication

This plugin is an _authentication provider_ that enables stateless, on-the-fly
configuration of remote desktop connections that are authorized using a
pre-shared key.


### Building

guacamole-auth-hmac uses Maven for managing builds. After installing Maven you can build a
suitable jar for deployment with `mvn package`.

The resulting jar file will be placed in `target/guacamole-auth-hmac-<version>.jar`.


### Installation & Configuration

Install the extension by moving the jar file to `/etc/guacamole/extensions` and restart tomcat7.
`guacamole-auth-hmac` adds two new config keys to `guacamole.properties`:

 * `secret-key` - The key that will be used to verify URL signatures.
    Whatever is generating the signed URLs will need to share this value.
 * `timestamp-age-limit` - A numeric value (in milliseconds) that determines how long
    a signed request should be valid for.


### Usage

 * `id`  - A connection ID that must be unique per user session. Can be a random integer ***or UUID***.
 * `timestamp` - A unix timestamp in milliseconds. This is used to prevent replay attacks.
 * `signature` - The SHA256 encrypted signature for authentication.
 * `guac.protocol` - One of `vnc` or `ssh`.
 * `guac.hostname` - The hostname of the remote desktop server to connect to.
 * `guac.port` - The port number to connect to.
 * `guac.username` - (_optional_)
 * `guac.password` - (_optional_)
 * `guac.*` - (_optional_) Any other configuration parameters recognized by
    Guacamole can be by prefixing them with `guac.`.


### Request Signing

Requests must be signed with an HMAC, where the message content is generated from the request parameters as follows:

 1. The parameters `timestamp`, `protocol`, `hostname`, `port`,  `username`, and `password` are concatenated with the secret key.
 1. Encrypt using SHA256.


### POST
Parameters are POSTed to `/guacamole/api/tokens` to authenticate. The response is then sent as JSON and contains `authToken` which is then used to login: `guacamole/#/client/(connection)?token=(authToken)`

`(connection)` is an encoded string that tells Guacamole to connect the user to a server. It is generated as follows:

1. Append `NULLcNULLhmac` to the shortened ID.
  - `NULL` represents a `NULL` character (often "\0").
  - `c` stands for connection.
  - `hmac` is the authentication provider.
1. Encode this with base64.

Then, add this to the URL after `guacamole/#/client/` and append the authToken parameter.

[More about using POST with Guacamole](https://glyptodon.org/jira/browse/GUAC-1102?jql=project%20%3D%20GUAC%20AND%20resolution%20%3D%20Unresolved%20AND%20priority%20%3D%20Major%20ORDER%20BY%20key%20DESC)

[Outline of how Guacamole receives and responds to authentication requests](https://sourceforge.net/p/guacamole/discussion/1110834/thread/8bea4c74/#102b)

[Explanation of the base64 encoded URL](https://sourceforge.net/p/guacamole/discussion/1110834/thread/fb609070/)


### Notes
- UUIDs can be used rather than integers as connection identifiers.
- Clicking the link twice *without refreshing* the page will log out the first connection window and login to the second one. The connection ID *does not* change, but the user ID *does change*.

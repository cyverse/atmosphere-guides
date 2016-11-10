# Swish/Badgekit Variable descriptions
Description of variables used in Swish Badgekit installation and Badgekit installation in general
##### [GLOBAL]
- BADGEKIT_ADMIN_REPO
 * The location of the Badgekit admin UI repo
- BADGEKIT_API_REPO
 * The location of the Badgekit API repo

##### [ANSIBLE]
- API_ENV_FILE_DEST
 * Location and name of ansible variables file for BADGEKIT ADMIN INSTALL settings
- MYSQL_SETTINGS_DEST
 * Location and name of ansible variables file for MYSQL settings
- API_INSTALL_DEST  
 * Location and name of ansible variables file for BADGEKIT API INSTALL settings
- ADMIN_INSTALL_DEST  
 * Location and name of ansible variables file for BADGEKIT ADMIN INSTALL settings
- GLOBAL_SETTINGS_DEST  
 * Location and name of ansible variables file for GLOBAL settings

##### [BADGEKIT API INSTALL]
- API_LOCAL_INSTALL
 * True if the API will be deployed locally on each node, False otherwise. Only affects database initialization/migration steps
- API_INSTALL_LOCATION 
 * Destination for API installation on node eg. /opt/dev/badgekit-api
- API_VARIABLES_FILE  
 * Destination for API env file on node eg. /opt/dev/badgekit-api/settings.env
- API_LOG_LOCATION  
 * Destination for API logs on node eg. /opt/dev/badgekit-api/api.log
 
##### [BADGEKIT ADMIN INSTALL]
- ADMIN_LOCAL_INSTALL 
 * True if the Admin will be deployed locally on each node, False otherwise. Only affects database initialization/migrations steps
- ADMIN_INSTALL_LOCATION  
 * Destination for admin installation on node eg. /opt/dev/badgekit-admin
- ADMIN_VARIABLES_FILE 
 * Destination for admin env file on node eg. /opt/dev/badgekit-admin/settings.env
- ADMIN_LOG_LOCATION  
 * Destination for admin logs eg. /opt/dev/badgekit-admin/admin.log

##### [BADGEKIT API VARIABLES]
- DB_HOST  
 * Badgekit API database host eg. localhost or thang.cyverse.org
- DB_NAME  
 * Name of badgekit API database
- DB_PASSWORD 
 * Password to badgekit API database
- DB_USER
 * User to log in to badgekit API database operations
- MASTER_SECRET 
 * API secret that needs to be used to make API calls
- API_PORT
 * Port to run API on

 ##### [BADGEKIT ADMIN VARIABLES]
- COOKIE_SECRET
 * The same secret as the Badgekit API MASTER_SECRET. Needed to make authenticated API calls.
- ADMIN_PORT
 * Port to run admin app on
- OPENBADGER_SYSTEM
 * Default system to use upon logging into admin app
- OPENBADGER_URL
 * Full url of badgekit API eg. http://thang.cyverse.org:8080
- OPENBADGER_SECRET
 * Should match MASTER_SECRET from badgekit api
- DATABASE_DRIVER
 * Just use mysql. Mozilla's documentation doesn't mention this it just has mysql for the driver everywhere.
- DATABASE_HOST
 * host of admin database eg. thang.iplantc.org
- DATABASE_USER
 * user to access admin database
- DATABASE_PASSWORD
 * password for DATABASE_USER
- DATABASE_DATABASE
 * name of admin database
- PERSONA_AUDIENCE
 * full url + port of where the admin app will be accessed from eg. http://thang.cyverse.org:80
- API_SECRET
 * Mozilla's docs don't talk about this much. They just say it should be a random string.
- BRANDING
 * text to place when "branding" a badge created through admin UI
- NODE_TLS_REJECT_UNAUTHORIZED
 * 1 to check SSL certs that don't match URL, 0 to ignore mismatches

##### [MYSQL]
- LOCAL_DATABASE_USER
 * If installing databases locally, what user to create/migrate with
- LOCAL_ADMIN_DATABASE_NAME
 * Name of admin database
- LOCAL_API_DATABASE_NAME
 * Name of API database
- LOCAL_DATABASE_PASSWORD
 * Password for LOCAL_DATABASE_USER

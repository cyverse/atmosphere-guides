## Setting Maintenance Records

Maintenance records are set separately for Atmosphere(2) and Troposphere. During maintenance, a configurable message is displayed to users, and user login is disabled.

To begin maintenance, enter the following commands on the Atmosphere(2) server:

```
tropomanage maintenance start --title "2017-12-12 - v30 Deployment" --message "Atmosphere is down for a Scheduled Maintenance, Today between 10am - 4pm MST." --start-now
atmomanage maintenance start --title "2017-12-12 - v30 Deployment" --message "Atmosphere is down for a Scheduled Maintenance, Today between 10am - 4pm MST." --start-now
```

To end maintenance, enter these commands:

```
atmomanage maintenance stop
tropomanage maintenance stop
```

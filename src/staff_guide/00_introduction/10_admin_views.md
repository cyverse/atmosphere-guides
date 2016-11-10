## Accessing the Django Administration Pages
<a name="staff_django_admin"></a>

### First, A warning about Django Administration Pages

It is important to note the amount of responsibility that one assumes when they are given access to these admin pages.

These pages can be thought of as a direct line into all of the available tables and rows in the database.

- "Objects" (Database entries) can be manually deleted and lost forever.
- Values can also be edited incorrectly and cause unforseen problems during a users experience.
- Scalar values that are changed can affect a wide variety of functionality, as an example:
  you should always *create* a new **Quota** rather than edit, because to edit would potentially change that value for >1 users.

Please, **USE CAUTION** when editing *any* entry directly.

#### Accessing the Django Administration Pages (Atmosphere)
From here, you have full access to all users, identities, requests, and other Atmosphere models.

##### Logging in through Django admin interface
In order to access the Django Administration Pages in Atmosphere your user must both have the `is_staff` and `is_superuser` privileges *AND a valid password*.
If you are using an LDAP backed Atmosphere, your "Normal" LDAP login should suffice.
If you are not, you will need a password set for you by another Atmosphere Staff user, or you must set your password via the REPL (See [Staff access](#staff_access) for more details).

Navigate to `https://<your_url>/admin` and log in as a staff user to access the Django admin interface.

#### Accessing the Django Administration Pages (Troposphere)
The Django Admin pages for Troposphere will allow you to manage MaintenanceRecords and other Troposphere models.

##### Logging in via Troposphere
If a user is staff, you can gain accessing to the Django Administration Pages by first logging in normally through Troposphere at `https://<your_url>/application`.
Next, redirect your browser to `https://<your_url>/tropo-admin`. From here you can manage Maintenance Records, which will block normal users from accessing the website.

##### Logging in via the Login interface
You can navigate directly to `https://<your_url>/tropo-admin` and log in as a staff user if you have an LDAP backed Atmosphere.

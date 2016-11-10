## Account Emulation

To emulate an account, you must be a staff user.
If you are not sure or need staff user access, see [Staff Access](#)

### Emulating a user through Troposphere
<a name="staff_emulate_ui"></a>

**To emulate a user, you must first log in to Troposphere as a staff user.**
First, login normally as the staff user.
Next, navigate to this page in your browser: `https://<your_url>/application/emulate/<username>`

After a series of redirections, you should see that the username in the Top Right corner has changed to the user you are intending to emulate.
If you are unable to emulate a user after several attempts, ensure that the username exists and is spelled properly.

##### Unemulate a user:
<a name="staff_no_emulate_ui"></a>
When done emulating a user, there are several options to 'disconnect' from the session:

1. navigate to `https://<your_url>/application/emulate/<your_username>`
1. navigate to `https://<your_url>/application/emulate` (NOTE: no username after `emulate`.)
1. You can also **logout** and upon the next login you should see your own account again.

How to emulate a user on Troposphere via the URL `https://<your_url>/application/emulate/<username>`:  
![Troposphere Emulation](./media/staff_emulate_application.gif)


### Emulating a user through the API

**To emulate a user, you must first log in to Atmosphere API as a staff user.**
<a name="staff_emulate_api"></a>
Note: If your site does **NOT** handle username/password validation (No LDAP) then a user/password combination must be created through Django first. The user must also have marked `is_staff` and `is_superuser` true.

After logging in as a staff user, navigate to `https://<your_url>/api/emulate/<username>`

From here, you will be able to perform actions through the Troposphere UI as if you were logged in as the user you are emulating.

##### Unemulate a user:
<a name="staff_no_emulate_api"></a>
When done emulating a user, you can either navigate to `https://<your_url>/api/emulate/<your_username>` or `https://<your_url>/api/emulate` with no username after `emulate.`

How to emulate a user on the Atmosphere API via the URL `https://<your_url>/api/emulate/<username>`:  
![Atmosphere API Emulation](./media/staff_emulate_api.gif)

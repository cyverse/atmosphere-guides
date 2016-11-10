## Granting staff access
<a name="staff_access"></a>

### What makes a Staff member in Atmosphere different from a regular user?

API Staff members have the ability to:

- Emulate end-users to help reproduce problems for the Atmosphere Team
- Respond to and accept resource requests in the Troposphere App.
- Respond to and accept imaging requests in the Troposphere App.
- Access the `/admin` built-in django administration pages.

Troposphere Staff members have the ability to:

- Access the `/admin` built-in django administration pages.

### How do I grant Staff access to the Atmosphere APIs to User X?
To get to Atmosphere's Python REPL:
```bash
cd /opt/dev/atmosphere # References the canonical 'dev' path.
source /opt/env/atmo/bin/activate  # References the canonical 'env' path.
./manage.py shell
```
Once inside Atmosphere's Python REPL:
```python
from core.models import AtmosphereUser
user = AtmosphereUser.objects.get(username='x')
user.is_staff = True
user.is_superuser = True
user.save()

# To set the users password at the same time
# (This is required if you want /admin access without LDAP)
# user.set_password('new_password')
```

### How do I grant Staff access to the Troposphere Admin pages to User X?
To get to Troposphere's Python REPL:
```bash
cd /opt/dev/troposphere # References the canonical 'dev' path.
source /opt/env/troposphere/bin/activate  # References the canonical 'env' path.
./manage.py shell
```
Once inside troposphere's Python REPL:
```python
from django.contrib.auth.models import User
user = User.objects.get(username='x')
user.is_staff = True
user.is_superuser = True
user.save()
```


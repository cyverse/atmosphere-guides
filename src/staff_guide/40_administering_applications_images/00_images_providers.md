## Administering Applications and Images

### Migrating Application/Image to a New Cloud Provider

You may have multiple cloud providers connected to your deployment, and you wish to make an existing Application (a.k.a. image) available on a new provider. This process is automated by `application_to_provider.py` in Atmosphere(2)'s `scripts/` folder.

This script will create image objects on the new provider, populate image data and metadata, and create appropriate records in the Atmosphere(2) database. Run `./application_to_provider.py --help` for more information on usage.

Example usage:
```
export PYTHONPATH=/opt/dev/atmosphere:$PYTHONPATH
export DJANGO_SETTINGS_MODULE=atmosphere.settings
source /opt/env/atmo/bin/activate
/opt/dev/atmosphere/scripts/application_to_provider.py 1378 7 --source-provider-id 4 --ignore-missing-owner --ignore-missing-members
```

### Synchronizing Applications/Images across Cloud Providers

`application_sync_providers.py` is a script which uses `application_to_provider` to synchronize all Applications (a.k.a. images) from a designated master provider to one or more replica providers. Run `./application_sync_providers.py --help` for more information on usage.

Example usage which synchronizes applications from Provider ID 7 (master) to 4 and 5 (replicas):
```
export PYTHONPATH=/opt/dev/atmosphere:$PYTHONPATH
export DJANGO_SETTINGS_MODULE=atmosphere.settings
source /opt/env/atmo/bin/activate
/opt/dev/atmosphere/scripts/application_sync_providers.py 7 4 5
```

### Troubleshooting images that aren't copying to replica providers

Sometimes images are not correctly copied to replica providers.  This leaves the system in a state
in which Atmosphere has database records for the image on that provider and therefore doesn't
attempt to copy the image but the provider can't actually launch and instance with that image
because it's either been partially copied or has some other error.

If you're ever in a situation where a particular image doesn't seem to ever get copied to a provider
despite running the `aplication_sync_providers.py` script, use the following steps to troubleshoot:

0. Delete the image in the destination provider cloud (e.g. using OpenStack)
1. Visit the page for the image that's not being copied in your browser and retrieve its application
   id (`application/images/<app_id>`)
2. Open a Django shell in the main Atmosphere container:
```
./manage.py shell
```
3. Import the necessary models and store the Application in question in a variable for later use:
```
from core.models import Application, ApplicationVersion, InstanceSource, ProviderMachine
app = Application.objects.get(id=<app_id>)
```
4.  Retrieve the ApplicationVersion that's not being copied over.  You can get a list of all
   ApplicationVersions that are active for an application by doing:
```
app.active_versions()
```
5. Store the ApplicationVersion that's not being copied over in a variable.  We'll call this
   variable `bad_version`.
6. Find the corresponding `ProviderMachines` for that `ApplicationVersion`:

```
ProviderMachine.objects.filter(application_version=bad_version.id)
```
7. Take note of the UUIDs for the `ProviderMachines` on the replica `Provider` and put it
   somewhere safe.  Then delete the `ProviderMachines` on the replica `Provider`.
8. Use the UUID from the previous step to find and delete the `InstanceSources` that have that UUID
   *and* are on the replica `Provider`:
```
$ InstanceSource.objects.filter(identifier=<uuid_from_last_step>)
```

9.  Run the `application_sync_providers.py` script as mentioned above for the correct providers and
    replicas.  This should copy the image to the replica provider.

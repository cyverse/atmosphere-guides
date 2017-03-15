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

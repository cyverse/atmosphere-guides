## Checking logs
<a name="staff_logs"></a>
The aggregate of all *Atmosphere* log output can be found at `<atmosphere_install_location/logs/atmosphere.log>`

Individual log files can be found in the same directory with a format of `atmosphere_<type>.log`. This includes:

- deploy 
- email 
- status 
- auth 
- API 
- libcloud

*Troposphere* logs can be found at `<troposphere_install_location/logs/troposphere.log>`
*Celery* logs can be found at `</var/log/celery/name_of_celery_node_1.log>`

Unlike Atmosphere logs, there is only one Troposphere log file. Here, you can see Troposphere authentication and API logs. 
Note that logrotation will be applied to most logs, so be sure you are looking in the right file relative to the date/time of the errors occurence.

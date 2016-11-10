## Flower
<a name='flower'>Flower</a> is a web based tool for monitoring and administrating Celery workers and tasks.

### Logging in to flower
To check flower, navigate to `https://<your_url>/flower` and log in using your flower credentials.

#### What are the flower credentials?
On the atmosphere server, run the command:
```
$ ps aux | grep flower
# OUTPUT example:
root     23488  0.0  1.9 611340 81872 pts/7    Sl   Jun03   4:11 python /opt/dev/atmosphere/manage.py celery flower --certfile=/etc/ssl/certs/server.org.crt --keyfile=/etc/ssl/private/server.key --port=8443 --log_file_prefix=/var/log/celery/flower.log --logging=warn --url_prefix=flower --basic_auth=USERNAME:PASSWORD
```
the `USERNAME:PASSWORD` is the same values that will be required when logging in to flower.

**If you don't have the flower credentials or server access, ask your site operators for more information.**

### Checking the status of a running task
View the status of recent celery tasks by clicking on the "Tasks" tab.

Search over the list of celery tasks by writing the `instance_id` or `username` into the search bar on the Top-Right corner.
View the fine-grained details of a task by clicking on the task `Name`. The most important details are:
`Traceback` (Finding the bug/failure), `Worker` (Finding the logs).

You can view tasks by status by clicking on the "Monitor" tab and clicking on your desired task state.


![Example login to flower](./media/staff_flower_login.gif)

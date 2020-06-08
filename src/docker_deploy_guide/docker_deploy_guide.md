# Atmosphere Release Deployment Process


## Two Weeks Prior to Release

1. Select a **crew chief** who will have the following duties:
    - Take ownership of the deployment to ensure this process is completed, delegating specific tasks as needed
    - Serve as point person for communication with other teams, leadership, etc
    - Ensure that driver has what he or she needs for a successful release


2. Select a **driver** who will have the following duties:
    - Perform technical deployment tasks
    - Communicate with crew chief regarding progress, setbacks, blocking issues, etc


- CyVerse Only:
    - Send maintenance notice to atmosphere-users; Post a maintenance banner to the [Atmosphere User Manual](https://pods.iplantcollaborative.org/wiki/display/atmman/Atmosphere+Manual+Table+of+Contents). Worst-case scenario: notice must be sent two working days prior to release.
    - Ensure maintenance window is on the "CyVerse Maintenance and Release Schedule" [calendar](https://wiki.cyverse.org/wiki/display/staff/Subscribe+to+CyVerse+Calendars)
    - Ensure a scheduled maintenance on status.io, see [instructions](https://github.com/cyverse/status-site/blob/master/docs/Maintenance.md)


- Jetstream Only:
    - Ensure that Jetstream tech team is aware of deployment date/time, on their calendar, notified their users, etc

<br>

## Week Prior to Release

### Create a release candidate
Each development cycle has a major release. During a relase, hotfixes will be applied and sometimes we will create patch releases. Each release is identified with a tag Major-Minor (ex. 34-0, or 34-1). A tag is used, because it always refers to an exact snapshot of the project and doesn't change. A release branch may continue to receive changes, and doesn't identify the project at any particular time.

To create the release candidate on Github:

  1. Update the changelog, moving "Unreleased" items into a named release
  2. Create a PR for these changes and merge into master
  3. Create and tag a new release by visiting the [releases page for the repo](https://github.com/cyverse/atmosphere/releases) and clicking "Draft a new release"
  4. This will trigger a new tagged build on Dockerhub
    - **NOTE**: If you cannot wait for the Dockerhub build to complete, do a shallow clone of Atmosphere/Troposphere and build (instead of including all branches and things from your local repository):
        ```shell
        git clone --depth 1 --branch v36-6 https://github.com/cyverse/atmosphere.git && cd atmosphere
        docker build -t cyverse/atmosphere:v36-6 .
        ```

### Prepare Release on Atmobeta
1. Merge PRs slated for release in Atmosphere, Troposphere, and Atmosphere-Ansible
2. Deploy release to atmobeta (See "Deployment Day" and apply to atmobeta)
3. Test changes on atmobeta
4. Prepare production variables
5. If you are creating a new server for this release, please refer to the [wiki documentation](https://wiki.cyverse.org/wiki/display/csmgmt/Atmosphere+Release+Deployment+Process)

<br>

## Deployment Day!

**Pre-deployment:** add the following to your aliases to save time typing:
```shell
alias atmosphere-docker="/opt/dev/atmosphere-docker/atmosphere-docker.sh -f /opt/dev/atmosphere-docker/docker-compose.prod.yml"
```

### Deploying Atmosphere-Docker for the First Time

1. Clone the [`atmosphere-docker`](https://github.com/cyverse/atmosphere-docker) and [`atmosphere-docker-secrets`](https://gitlab.cyverse.org/atmosphere/atmosphere-docker-secrets) repositories - typically do this at `/opt/dev/`

2. Setup PostgreSQL
    1. Install PostgreSQL with `apt-get` (Google to find up-to-date guide)
    2. Edit `/etc/postgresql/<version>/main/postgresql.conf` to uncomment `listen_addresses = 'localhost'` and add Docker host: `listen_addresses = 'localhost,172.17.0.1'`
    3. Also sure that `ssl = off`, otherwise it will cause issues with user login
    
    4. Edit `/etc/postgresql/<version>/main/pg_hba.conf` to add this line which will allow connections from within the Docker network:
        ```
        host    all             all             172.16.0.0/12           md5
        ```
    5. Restart PostgreSQL: `systemctl restart postgresql`
    6. Create `atmo_app` user and databases:
        ```SQL
        CREATE USER atmo_app WITH CREATEDB NOSUPERUSER CREATEROLE;
        ALTER USER atmo_app WITH PASSWORD 'password';
        -- Reconnect as atmo_app user
        CREATE DATABASE atmo_prod;
        CREATE DATABASE troposphere;
        ```
    7. Load data from database dumps:
      ```shell
      psql -h localhost -U atmo_app atmo_prod < data_base_dump
      psql -h localhost -U atmo_app troposphere < data_base_dump
      ```

3. Continue to [Upgrading with Atmosphere-Docker](#upgrading-with-atmosphere-docker) instructions

<br>

### Upgrading with Atmosphere-Docker

1. Even though the database is outside of Docker and should not be touched, back it up:
    ```shell
    pg_dump -U atmo_app atmo_prod > "/root/atmo-$(date +%F).sql"
    pg_dump -U atmo_app troposphere > "/root/tropo-$(date +%F).sql"
    ```

2. Start maintenance for Atmosphere and Troposphere
    ```shell
    atmosphere-docker exec troposphere /bin/bash -c \
      "source /opt/env/troposphere/bin/activate && ./manage.py maintenance start \
      --title '2019-06-16 v36-1 deployment' \
      --message 'Atmosphere is down for a Scheduled Maintenance, Today between 9am - 4pm MST.'"

    atmosphere-docker exec atmosphere /bin/bash -c \
      "source /opt/env/atmo/bin/activate && ./manage.py maintenance start \
      --title '2019-06-16 v36-1 deployment' \
      --message 'Atmosphere is down for a Scheduled Maintenance, Today between 9am - 4pm MST.'"
    ```
    - If there is a separate proxy server or nginx for Atmosphere - atmo.cyverse.org for Cyverse prod and use.jetstream-cloud.org for Jetstream prod - switch that over to a maintenance message:
      ```shell
      cd /etc/nginx/sites-enabled
      ln -sf /etc/nginx/sites-available/default proxy.conf
      systemctl restart nginx
      ```
    - You could also set this (and #8 below) up as 'at' jobs on the proxy server beforehand to get done automatically
      
3. Checkout the correct branch of `atmosphere-docker-secrets` - prod, jetstream-prod, atmobeta, etc - and double-check that variables look correct for this server and consist of your latest updates, if any

4. Stop the current containers and back them up to images
    ```shell
    atmosphere-docker stop
    docker commit atmosphere-docker_atmosphere_1 old_atmosphere-docker_atmosphere
    docker commit atmosphere-docker_atmosphere_1 old_atmosphere-docker_atmosphere
    ```
    - Unfortunately, there is no way to preserve the containers without creating an image. Even if you rename the containers, docker-compose uses the IDs

5. Make sure `atmosphere-docker` repository is up-to-date (be careful to note any significant changes before doing this!)
    ```shell
    git reset --hard
    git pull
    ```

6. Edit `docker-compose.prod.yml` to use image tags from the new release if changes are not already in the repository and start containers
    ```shell
    atmosphere-docker pull
    atmosphere-docker up -d
    ```
    - If you have trouble with this, type the whole thing out (see alias above)

7. Use and test, test, test
    1. Also do apt-updates/apt-upgrades and reboot the server 
    2. Check logs are rotating okay and not getting too big
    3. Delete any unnecessary images
    4. If there are issues with containers connecting to postgres, restart service postgresql

8. Once you are confident the services are ready-to-go, remove the maintenance message from the proxy server
    ```shell
    cd /etc/nginx/sites-enabled
    ln -sf /etc/nginx/sites-available/proxy.conf proxy.conf
    systemctl restart nginx
    ```

9. End the maintenance by removing maintenance messages from Atmosphere and Troposphere 
    ```shell
    atmosphere-docker exec troposphere /bin/bash -c \
      "source /opt/env/troposphere/bin/activate && ./manage.py maintenance stop"

    atmosphere-docker exec atmosphere /bin/bash -c \
      "source /opt/env/atmo/bin/activate && ./manage.py maintenance stop"
    ```
    - If this isn't working, go inside the containers for both atmo and tropo and run `./manage.py maintenance stop`

<br>

## Hotfixing

The wonderful thing about Docker and containers in general is that they are easy to create and destroy. Also, changes inside the container do not have to be reflected outside the container to the services interacting with it. This gives us the ability to easily swap out one container for a new one.

Imagine you want to deploy an important change that cannot wait until the next scheduled maintenance. Once you have a container image ready with this new feature, follow these instructions:

  1. Edit the `docker-compose.prod.yml` file with the new image tag

  2. Scale up the Atmosphere service:

  ```
  ./atmosphere-docker.sh -f docker-compose.prod.yml up -d --scale atmosphere=2 --no-recreate --no-deps
  ```

  - By scaling atmosphere up, compose will create a new container alongside the first one. It will now load-balance round robin style between the two containers
  - The `--no-recreate` flag here is very important to avoid stopping and deleting the original, out-of-date container

  3. Wait for the new container (`atmosphere_2`) to finish the setup tasks, then stop and delete the original:

  ```
  docker kill atmosphere-docker_atmosphere_1
  docker rm atmosphere-docker_atmosphere_1
  ```

  - Note: the container names may be slightly different than above
  - Unfortunately, the new container will always have the `2` index and will require `--index=2` on all compose commands interacting with that container. **On Jetstream, add this to entries in the crontab after completing the next step**
    - Scaling back down to 1 will delete the newest container
    - Renaming will not change anything since docker-compose relies on immutable labels

  4. Now you will need to restart Nginx, probably due to the way the underlying docker network handles hostname mapping:

  ```
  ./atmosphere-docker.sh -f docker-compose.prod.yml exec troposphere bash
  service nginx restart # inside troposphere container
  ```

  5. Remember to update any crontab entries using `docker-compose` to include `--index=2`

# Atmosphere Release Deployment Process


## Two Weeks Prior to Release

1. Select a **crew chief** who will have the following duties:
    - Take ownership of the deployment to ensure this process is completed, delegating specific tasks as needed
    - Serve as point person for communication with other teams, leadership, etc
    - Ensure that driver has what he or she needs for a successful release


2. Select a **driver** who will have the following duties:
    - Perform technical deployment tasks
    - Communicate with crew chief regarding progress, setbacks, blocking issues, etc

<br>

- CyVerse Only:
    - Send maintenance notice to atmosphere-users; Post a maintenance banner to the [Atmosphere User Manual](https://pods.iplantcollaborative.org/wiki/display/atmman/Atmosphere+Manual+Table+of+Contents). Worst-case scenario: notice must be sent two working days prior to release.
    - Ensure maintenance window is on the "CyVerse Maintenance and Release Schedule" [calendar](https://wiki.cyverse.org/wiki/display/staff/Subscribe+to+CyVerse+Calendars)
    - Ensure a scheduled maintenance on status.io, see [instructions](https://github.com/cyverse/status-site/blob/master/docs/Maintenance.md)


- Jetstream Only:
    - Ensure that Jetstream tech team is aware of deployment date/time, on their calendar, notified their users, etc


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


## Deployment Day

**Pre-deployment:** add the following to your aliases to save time typing:
```shell
alias atmosphere-docker="/opt/dev/atmosphere-docker/atmosphere-docker.sh -f /opt/dev/atmosphere-docker/docker-compose.prod.yml"
```

### Deploying Atmosphere-Docker for the First Time

1. Clone the [`atmosphere-docker`](https://github.com/cyverse/atmosphere-docker) and `atmosphere-docker-secrets` repositories

2. Continue to [Upgrading with Atmosphere-Docker](#upgrading-with-atmosphere-docker) instructions


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
    - If there is a separate proxy server or nginx for Atmosphere, switch that over to a maintenance message:
      ```shell
      rm /etc/nginx/sites-enabled/proxy.conf
      ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
      systemctl restart nginx
      ```

3. Checkout the correct branch of `atmosphere-docker-secrets` and double-check variables

4. Stop the current containers and back them up to images
    ```shell
    atmosphere-docker stop
    docker commit atmosphere-docker_atmosphere_1 old_atmosphere-docker_atmosphere
    docker commit atmosphere-docker_atmosphere_1 old_atmosphere-docker_atmosphere
    ```
    - Unfortunately, there is no way to preserve the containers without creating an image. Even if you rename the containers, docker-compose uses the IDs

5. Make sure `atmosphere-docker` repository is up-to-date (be careful to note any significant changes before doing this)
    ```shell
    git reset --hard
    git pull
    ```

6. Edit `docker-compose.prod.yml` to use image tags from the new release if changes are not already in the repository and start containers
    ```shell
    atmosphere-docker pull
    atmosphere-docker up -d
    ```

7. Use and test

8. Once you are confident the services are ready-to-go, end the maintenance
    ```shell
    atmosphere-docker exec troposphere /bin/bash -c \
      "source /opt/env/troposphere/bin/activate && ./manage.py maintenance stop"

    atmosphere-docker exec atmosphere /bin/bash -c \
      "source /opt/env/atmo/bin/activate && ./manage.py maintenance stop"
    ```

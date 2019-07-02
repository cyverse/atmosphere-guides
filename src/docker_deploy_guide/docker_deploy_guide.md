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


### Prepare Release on Atmobeta
1. Merge PRs slated for release in Atmosphere, Troposphere, and Atmosphere-Ansible
2. Deploy release to atmobeta (See "Deployment Day" and apply to atmobeta)
3. Test changes on atmobeta
4. Prepare production variables
5. If you are creating a new server for this release, please refer to the [wiki documentation](https://wiki.cyverse.org/wiki/display/csmgmt/Atmosphere+Release+Deployment+Process)


## Deployment Day

**First, create an alias for `atmosphere-docker` to save time typing**:
```shell
alias docker-compose='docker-compose -f /opt/dev/atmosphere-docker/docker-compose.prod.yml'
```


### Deploying Atmosphere-Docker for the First Time

1. Get database dumps from the old production and copy them to `/opt/dev/atmosphere-docker/postgres/`
    ```shell
    docker-compose exec postgres pg_dump -U atmo_app atmo_prod > "/root/atmo-$(date +%F).sql"
    docker-compose exec postgres pg_dump -U atmo_app troposphere > "tropo-$(date +%F).sql"
    ```

2. Clone the `atmosphere-docker` and `atmosphere-docker-secrets` repositories

3. Continue to [Upgrading with Atmosphere-Docker](#upgrading-with-atmosphere-docker) instructions


### Upgrading with Atmosphere-Docker

1. Start maintenance for Atmosphere and Troposphere
    ```shell
    docker-compose exec troposphere /bin/bash -c \
      "source /opt/env/troposphere/bin/activate && ./manage.py maintenance start \
      --title '2019-06-16 v36-1 deployment' \
      --message 'Atmosphere is down for a Scheduled Maintenance, Today between 9am - 4pm MST.'"

    docker-compose exec atmosphere /bin/bash -c \
      "source /opt/env/atmo/bin/activate && ./manage.py maintenance start \
      --title '2019-06-16 v36-1 deployment' \
      --message 'Atmosphere is down for a Scheduled Maintenance, Today between 9am - 4pm MST.'"
    ```

2. Checkout the correct branch of `atmosphere-docker-secrets` and double-check variables

3. Stop the current containers and back them up to images
    ```shell
    docker-compose stop
    docker commit atmosphere-docker_atmosphere_1 old_atmosphere-docker_atmosphere
    docker commit atmosphere-docker_atmosphere_1 old_atmosphere-docker_atmosphere
    ```
    - Unfortunately, there is no way to preserve the containers without creating an image. Even if you rename the containers, docker-compose uses the IDs

4. Make sure `atmosphere-docker` repository is up-to-date (be careful to note any significant changes before doing this)
    ```shell
    git reset --hard
    git pull
    ```

5. Edit `docker-compose.prod.yml` to use image tags from the new release and start containers
    ```shell
    docker-compose pull
    docker-compose up -d
    ```

6. Use and test

7. Once you are confident the services are ready-to-go, end the maintenance
    ```shell
    docker-compose exec troposphere /bin/bash -c \
      "source /opt/env/troposphere/bin/activate && ./manage.py maintenance stop"

    docker-compose exec atmosphere /bin/bash -c \
      "source /opt/env/atmo/bin/activate && ./manage.py maintenance stop"
    ```

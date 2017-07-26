# Atmosphere Project Contribution Guide

This guide is intended to orient community members who are interested in contributing to Atmosphere -- learn about our development process, our technology stack, and our release strategy. Welcome to the project!

This page has a couple of broken links, having recently been migrated from an internal wiki -- they will be fixed soon once the linked content is migrated to atmosphere-guides.


## What is Atmosphere?

Atmosphere or 'atmo' can refer to several different things:

- [Atmosphere](https://atmo.cyverse.org/application)(0), CyVerse's "cloud computing for scientists" service
- Atmosphere(1), **the free, open-source software project** which powers the above service (and is the primary focus of these guides)
- [Atmosphere](https://github.com/iPlantCollaborativeOpenSource/atmosphere)(2), the API and back-end component of the above software project

For clarity, this page will disambiguate all uses of "Atmosphere".

## What are the steps to contributing to Atmosphere/Core services?

Contribution to core-services products (usually) takes place in two different environments:

1. [JIRA](https://pods.iplantcollaborative.org/jira/secure/Dashboard.jspa) - This is an external service where we document bugs, issues, and new features to be fixed.
2. [Github](https://github.com/cyverse/) - This is where our codebase generally resides. See [Where is the code](#where-is-the-code) for more details.

### The Atmosphere workflow for JIRA tickets
    1.  Issues/Bugs/New Features that are found in the wild, during requirements gathering, etc. should be created as "JIRA Tickets" and assigned a **fixVersion** of **Release Backlog** or **Product Backlog**.
        1.  **JIRA **Operations**-note:** At this time the form only lets you set **affectedVersion**, which is not quite the same. We should make this easier for specific users (if the workflow allows for it)
2.  **JIRA Sprints and the Agile Board**
    1.  **Tickets are assigned** to match with the **Release** and **Sprint **Schedule:
    2.  Currently, core-services is on a **5 week** release schedule. There are **two 2-week sprints** and a **1-week sprint** **to prepare for and release** the branch to the production servers.
    3.  JIRA Tickets for both 2-week sprints are regularly assigned at the beginning of each release.
        1.  During the first sprint after a release, primarily 'Bug' tickets will be assigned. This is done to give time for the changes to "settle" on the beta server for a few weeks.
        2.  During the second sprint, primarily "Improvements and new feature" tickets will be assigned.
    4.  The third sprint, only one week long, will be split between preparing for deployment and finishing up any lingering tickets that extend past the sprint deadline.
3.  **The Lifecycle of a ticket**
    1.  **Starting work on a ticket**
        1.  (If applicable) Tickets will move to `**Start Design**` and work with the design pipeline to gather requirements (See The Design Pipeline section for more details)
        2.  Put the ticket into "**Start Progress**" and start writing Code to fix the bug/create the feature. 
        3.  Tests are written for any new bug to verify the failure has been fixed and for any new feature to help with QA. (See the Testing the Code section for more details)
        4.  Documentation is written (See the Documenting the Code section for more details)
    2.  **Reviewing a ticket**
        1.  Ensure that the checklist for your PR template is complete before requesting review. (see below for more details)
        2.  Put the ticket into "**Review**" step and assign to a project lead. (See Reviewing Code section for more details)
        3.  Upon merge, a project lead will move the ticket to **Resolved** and assigned to QA for final approval/confirmation. Notes should be included that point to the new tests/documentation as appropriate.

### Using github to work on an issue/bug/feature
1.  **Fork the repo you intend to work on**
    1.  If this is your first time contributing to a core-services repository, you will want to create a new fork.<span style="color: rgb(34,34,34);"> </span>Forking a repository<span style="color: rgb(34,34,34);"> allows you to freely experiment with changes without affecting the original project.</span>
    2.  <span style="color: rgb(34,34,34);">Github's documentation for working with forks is [available here](https://help.github.com/articles/fork-a-repo/).</span>
2.  **<span style="color: rgb(34,34,34);">Creating a feature branch</span>**
    1.  Before starting work on a new feature or bugfix, you should create a new branch. Creating branches for your work allows you to isolate your changes when they are ready for others to review. It also gives you the ability to change to another branch, to work on separate fixes or features as necessary.
3.  **Submitting a Pull Request**
    1.  It's a good idea to make pull requests early on. A pull request represents the start of a discussion, and doesn't necessarily need to be the final, finished submission.
    2.  It's also useful to remember that if you have an outstanding pull request then pushing new commits to your GitHub repo will also automatically update the pull requests.
    3.  **Specific to Core-services:** Pull requests will be reviewed **after** the "Check list" in the Pull Request template has been completed, this should include new tests and documentation!
    4.  GitHub's documentation for working on pull requests is [available here](https://help.github.com/articles/using-pull-requests).


#### Pull Request Templates

The pull request template used by core-services can be found on the github of Atmosphere or Troposphere in .**/PULL_REQUEST_TEMPLATE**

> <span style="color: rgb(255,0,0);">**NOTE:** Proposals for those PR templates can be found here, and can be updated prior to merge: [<span style="color: rgb(255,0,0);">https://github.com/cyverse/troposphere/pull/536</span>](https://github.com/cyverse/troposphere/pull/536) and [<span style="color: rgb(255,0,0);">https://github.com/cyverse/atmosphere/pull/250</span>](https://github.com/cyverse/atmosphere/pull/250)</span>

See this article for including a pull request template in your repository: [https://help.github.com/articles/creating-a-pull-request-template-for-your-repository/](https://help.github.com/articles/creating-a-pull-request-template-for-your-repository/)

## Where is Atmosphere Deployed?

Atmosphere(1) is deployed at CyVerse as Atmosphere(0), but also at several other organizations known by different names:

- [Jetstream Cloud](http://jetstream-cloud.org/) (partnership of Indiana University, TACC, & CyVerse - Jetstream GitHub Organization: [jetstream-cloud](https://github.com/jetstream-cloud))
- MOC (Massechusetts Open Cloud) (Jonathan Bell: [github-profile](https://github.com/lokI8), Lucas H. Xu: [github-profile](https://github.com/xuhang57))
- Duke University / Duke Center for Genomic & Computational Biology ([Duke GCB](https://github.com/Duke-GCB)) (Darren Boss: [gcb-profile](https://genome.duke.edu/directory/gcb-staff/darren-boss); [github-profile](https://github.com/netscruff))

## Resources and Docs for New Contributors

Familiarize yourself with the following links and use them as a reference. (Also check out the other guides on this site!)

- [Atmosphere Code Guidelines](./code_guidelines.html)
- [Atmosphere Troubleshooting Guide](./troubleshooting_guide.html)
- [Atmosphere(2) API docs on Apiary](http://docs.atmospherev2.apiary.io/)

## Where is the Code?

### Repositories on Github

(Should we make this a table of repo + link + purpose?)

- [atmosphere](https://github.com/iplantcollaborativeopensource/atmosphere)(2), and supporting projects:
    - [django-iplant-auth](https://github.com/iPlantCollaborativeOpenSource/django-iplant-auth) (used by Django backends of Atmosphere & Troposphere)
    -  [subspace](https://github.com/iPlantCollaborativeOpenSource/subspace) (runs the Ansible for instance deploys)
    - [rtwo](https://github.com/iPlantCollaborativeOpenSource/rtwo)
    - [chromogenic](https://github.com/iPlantCollaborativeOpenSource/chromogenic) (Imaging using in Atmosphere)
    - [threepio](https://github.com/jmatt/threepio) (will be replaced as Django logging has improved since it was created)
    - [atmosphere-v2-apiary-docs](https://github.com/iPlantCollaborativeOpenSource/atmosphere-v2-apiary-docs), some API documentation?
    - [atmosphere-apiary-docs](https://github.com/iPlantCollaborativeOpenSource/atmosphere-apiary-docs), some old API documentation?
- [troposphere](https://github.com/iplantcollaborativeopensource/troposphere), and supporting projects:
    - [troposphere-ui,](https://github.com/cyverse/troposphere-ui) soon to be used by Troposphere
- [atmosphere-ansible](https://github.com/iPlantCollaborativeOpenSource/atmosphere-ansible)
- [clank](https://github.com/iPlantCollaborativeOpenSource/clank), Ansible-based automation which deploys Atmosphere(1)
- [nginx_novnc_auth](https://github.com/cyverse/nginx_novnc_auth)
- [edwins/GateOne](https://github.com/edwins/GateOne)
- [ansible-gateone-server](https://github.com/cyverse/atmosphere-guides)
- [atmosphere-guides](https://github.com/cyverse/atmosphere-guides) documentation for Atmosphere(1)

## Key Terms

You'll hear these a lot on the Atmosphere project:

- _Instance_: a Virtual Machine (VM) or "cloud computer" running on Atmosphere(0) / OpenStack.
- _Image:_ a [disk image](https://en.wikipedia.org/wiki/Disk_image) of a Virtual Machine (with some metadata) from which instances are created.
- _Allocation_: the amount of "CPU time" that a user is allotted, measured in AUs (see below).
- _Allocation Unit_ _(AU)_: "roughly equivalent to using one CPU-hour, or to using one CPU core for one hour." ([source](https://pods.iplantcollaborative.org/wiki/display/atmman/Requesting+More+Atmosphere+Resources))
- _Modal_: a [modal window](https://en.wikipedia.org/wiki/Modal_window) in a GUI; the Troposphere UI uses these extensively.

## Technology Stack Overview

This is intended to be an orientation to the main components of Atmosphere(1), their purpose, and their supporting technologies.

### Atmosphere(1)

Atmosphere(1), broadly, is a web application which supports user-friendly access to (and management of) cloud computing resources, such as virtual machines (servers/workstations) and storage volumes.

Atmosphere(1) has a "micro-services" architecture in that the back-end API is separated from the front-end UI, but all deployments to date contain all components on one operating system environment (server).

#### Atmosphere(2) API and Back-End

The API is written in Python using the [Django](https://www.djangoproject.com/) web framework, backed by a [PostgreSQL](https://en.wikipedia.org/wiki/PostgreSQL) database. As is typical for Django applications, Atmosphere(2) interacts with its database using Django's [object-relational mapper](https://en.wikipedia.org/wiki/Object-relational_mapping).

Things that Atmosphere(2) does:

- Interacts with cloud provider APIs to provision resources (instances, block storage volumes)
- Initiates Ansible playbook runs on new and redeployed instances
- Authenticates users
- Keeps track of user [allocations](http://www.cyverse.org/service-level-agreement#AtmoAllo)

The API is [apparently documented here](http://docs.atmospherev2.apiary.io/#reference).

#### Troposphere UI

[Troposphere](/wiki/display/csmgmt/Troposphere) is a separate front-end for Atmosphere(1), consisting of a Django application and JavaScript "single-page application" built with the [React](https://facebook.github.io/react/) front-end framework. Troposphere can be thought of as a JavaScript client which interacts with Atmosphere(2) via RESTful API.

#### Web Server

Both Atmosphere(2) and Troposphere are served by Nginx, which serves static assets directly and reverse proxies to uWSGI (etc.) for dynamically generated content.

#### atmosphere-ansible

atmosphere-ansible is the set of Ansible code that runs on newly provisioned cloud instances as part of the deployment process.

##### Subspace

[Subspace](https://github.com/iPlantCollaborativeOpenSource/subspace) is a Python project that programmatically runs Ansible playbooks; Atmosphere(2) uses it to run atmosphere-ansible.

### Clank

[Clank](https://github.com/iPlantCollaborativeOpenSource/clank) is the set of automations that deploy Atmosphere(1) and most of its components.

Clank wraps the deployment process using Ansible, but significant parts are still automated with a mix of bash scripting, makefile, and a custom Python "configure" script which generates application configuration from jinja2 templates and .ini files. Also, unlike other Ansible code that you may have seen, Clank must be run locally on the destination server, not from a remote deployment host. The future direction is to refactor this into idiomatic Ansible and remove some layers of indirection.


### Monitoring and Management

These are optional integrations which are implemented for Atmosphere(0). They are not necessary for a successful Atmosphere(1) deployment.

#### ELK

[ELK stack](http://logz.io/learn/complete-guide-elk-stack/) (Elasticsearch, Logstash, Kibana) handles logging information from Atmosphere-Ansible.

#### New Relic

#### Sentry

???

### OpenStack

Atmosphere(1) is intended to be agnostic of cloud provider type, but all current deployments use OpenStack as the cloud provider back-end. OpenStack is a collection of projects which, together, provide infrastructure-as-a-service or a 'cloud'.

### Remote Access Methods

Atmosphere(1) supports several means of users accessing their instances.

#### SSH

Users can create a secure shell to their VMs directly over the internet, authenticating either with their Atmosphere(0) credentials or with an SSH keypair. Atmosphere(1) is essentially uninvolved in this workflow, though it provides a way for users to automatically install their public SSH key on new and re-deployed instances.

#### Web Shell

Web Shell gets you a command line session in your browser, launched from the Troposphere UI. Web Shell uses [Gate One](https://liftoff.github.io/GateOne/About/index.html), a web-based terminal emulator. The Gate One server creates an SSH connection to the instance and exposes that shell to the user in a web interface, proxying the SSH traffic. For Atmosphere(0), the GateOne server is known as "bob" / "atmo-proxy".

See [GateOne Background](./gateone_background.html) for detailed design and troubleshooting information.

#### Web Desktop

Web Desktop gets you a graphical desktop session in your browser, launched from the Troposphere UI. Web Desktop uses [NoVNC](https://kanaka.github.io/noVNC), a web-based VNC client. This is brokered through webaccess.cyverse.org.

[https://github.com/cyverse/nginx_novnc_auth](https://github.com/cyverse/nginx_novnc_auth)

[https://github.com/cyverse/clank/blob/master/playbooks/utils/install_novnc_auth.yml](https://github.com/cyverse/clank/blob/master/playbooks/utils/install_novnc_auth.yml)

#### Future: Guacamole

[Guacamole](http://guacamole.incubator.apache.org/) is an HTML5 remote desktop gateway which provides both a command-line shell and a graphical desktop. Guacamole is planned as a replacement for Gate One and NoVNC, though this is not implemented in production yet.

## Clouds

Atmosphere(0, 1, 2) provisions virtual machines on several 'clouds' which actually host the instances and computing infrastructure. Currently, all cloud providers use OpenStack. It is also possible for Atmosphere to provide access to commodity IaaS like Amazon Web Services (AWS), though this is not currently configured.

## Tools and Workflows

### Common Technologies and Tools

No matter your sub-specialty, you'll work with most/all of these as a member of the Atmosphere Team.

- Python programming language, used for Atmosphere(2), Ansible, Subspace
- Ansible, used for configuration management and infrastructure automation
- YAML markup language, used for Ansible code and variables files
- Markdown markup language, used for documentation
- SSH, used for remotely accessing servers
- git and Github, used for source control

### Local Development Environment

The local development environment-in-a-box is not yet published for community consumption. Coming soon!

### Issue Tracking Systems

The Atmosphere(0) team uses several internal systems to track development cycles and support issues. Unfortunately these are not accessible to community members. For now, please use the repository-specific Issues section in the appropriate GitHub repository (perhaps [atmosphere](https://github.com/cyverse/atmosphere)(2)) to report an issue with Atmosphere(1,2).

If you are an Atmosphere(0) *user* seeking assistance and you ended up here for some reason, please log into [Atmosphere](https://atmo.cyverse.org/) and click the "Feedback & Support" link at the bottom of the page, or email support at cyverse dot org.

### Contributing Code

Note that the following information may change soon as the Atmosphere(0) team refines the development process for Atmosphere(1).

#### On Github

Most of Atmosphere(1)'s code lives on GitHub. Contributions to these codebases should follow a fork-and-pull-request workflow.

1.  Create your own fork of the repository, work on the code there, test it in your local development environment
2.  Create a pull request
3.  Have someone else review and merge your pull request; ideally two people will review it.

Forward-facing projects that are critical to Atmosphere(1) have designated point maintainers. Pull requests to these projects should be approved by the point maintainer when possible:

- [Atmosphere](https://github.com/iplantcollaborativeopensource/atmosphere)(2): [Steve Gregory](https://github.com/steve-gregory)
- [Troposphere](https://github.com/iPlantCollaborativeOpenSource/troposphere): [Andrew Lenards](https://github.com/lenards)

Ancillary projects have a wider set of individuals with write access, these are typically members of the Atmosphere(0) team at CyVerse.

## How Atmosphere is Tested

The stack is tested at various levels; test coverage and the testing process is a work in progress.

### Django tests in Atmosphere(2)

Unit tests written by developers can be found throughout the codebase. These tests are not currently running as part of regular build/deploy workflow, but we could!

### [Travis CI](https://travis-ci.org/) running style & bundle/compile tests for Troposphere

- see [.travis.yml](https://github.com/iPlantCollaborativeOpenSource/troposphere/blob/master/.travis.yml) in Troposphere for configuration
- [Troposphere test results on Travis CI](https://travis-ci.org/iPlantCollaborativeOpenSource/troposphere)

### QA Team tests using Robot Framework and JMeter

Note that the following information describes processes performed by the QA Team at CyVerse who primarily support Atmosphere(0), but their effort certainly also benefits Atmosphere(1). This team is also responsible for testing other CyVerse products (e.g. Discovery Environment). Some resources described in this section are currently only accessiblt to members of CyVerse staff.

Tests are built based on QA team using and reverse engineering Atmosphere(1) on atmobeta.cyverse.org, and the history of internal JIRA issues. QA team does not currently receive product specifications or release notes.

Individual tests are tagged in a few dimensions:

- Type of test
    - Smoke tests, which confirm very basic communication/functionality/existence of API and UI objects
    - Functional tests, which confirm the actual functioning ("golden path") of API endpoints and UI objects
    - Regression tests, which confirm that resolved issues do not recur and pushes boundaries
- Layer of stack under test
    - Atmosphere(2) API (HTTP calls using curl)
    - Troposphere UI (browser driven with Selenium)

atmobeta.cyverse.org is tested nightly, and test results can be found on [https://shimerdas.iplantcollaborative.org:8443](https://shimerdas.iplantcollaborative.org:8443). (You must be a member of CyVerse staff and on an internal network to access shimerdas Jenkins server.) Only atmobeta is targeted during _regression_ testing.

atmo-dev.cyverse.org is tested as part of each continuous deployment. Jenkins runs tests against atmo-dev in two jobs (these links are only accessible to CyVerse staff):

- [Test_Atmosphere](https://atmo-dev.cyverse.org/jenkins/job/Test_Atmosphere/) (API tests)
- [Test_Troposphere](https://atmo-dev.cyverse.org/jenkins/job/Test_Troposphere/) (GUI tests)

Test coverage is greater for the Atmosphere(2) API than for the Troposphere UI. QA team's tests do not currently confirm that instances launch, nor do they execute the various instance access workflows (e.g. Web Shell and Web Desktop), but it is possible for this coverage to be added.

If a test fails repeatedly, QA team files a JIRA ticket, tags the test with the JIRA number, and disables that test until the issue is resolved.

More information on the QA team's work can be found on [qa-4.cyverse.org](http://qa-4.cyverse.org), including the [automated test suites](http://qa-4.cyverse.org/Atmosphere/) and how to run test suites locally ([1](http://qa-4.cyverse.org/robotframework/misc/html/RobotFramework_and_iPlant.txt), [2](http://qa-4.cyverse.org/robotframework/misc/html/RobotFramework_Setup_for_iPlant-OLD.txt)). (Only accessible to CyVerse staff.) Note that much of the information is for other CyVerse projects, and some test framework dependencies are unnecessary if you are only testing Atmosphere.

### [Operation Sanity](https://github.com/cyverse/operation-sanity) behavioral testing

Operation Sanity is a set of test suites written using behave, which drive a browser using Selenium. Operation Sanity exercises common Atmosphere workflows as a user: launches several instances against multiple cloud providers, ensures that those instances launch, creates and attaches volumes, and so forth. It is intended to run these tests in parallel so that long operations (e.g. waiting for an instance to launch) do not block execution.

Operation Sanity is currently in a "proof of concept" state, and is currently not run automatically. There is some intended functionality (e.g. testing launch of Web Shell and Web Desktop) which needs to be built.

## Releases and Development Cycles

You can see a list of releases as branches in each GitHub repository, e.g. [Atmosphere(2)](https://github.com/cyverse/atmosphere/branches).

### Release Naming

Name should be two words, a hyphen will be added between them. Hyphenated bird names used to be the golden ticket (Abyssinian-nightjar,california-condor) but we now allow for alliterative adjective/verb and bird name combinations (ex: jamming-junglefowl, mystifying-merlin, nautical-nighthawk). Helpful Link: [Birds Beginning with Letters](http://thewebsiteofeverything.com/animals/birds/beginning-with/A)

### Approach to Tagging Releases
In order to identify which release a repository is associated with, we need to "tag", or annotate, the association. Currently, we name branches by release for Atmosphere & Troposphere. However, there are dependencies in the instance deployment automation managed in Atmosphere-Ansible repository. This repo is used by "subspace" via Atmosphere API - yet, we are not explicitly denoting the Atmosphere-Ansible tested, verified, and deployed with an Atmosphere release.

I suggest that we use ["annotated-tags"](https://git-scm.com/book/en/v2/Git-Basics-Tagging#Annotated-Tags) over lightweight tags; this allows for a "tag name" and a message.

Given that we use letter-based alliterations for release names, I suggest was use a two-digit year plus letter initials as our _annotation_. So, petrified-penguin would be 16.p-p as the initial release. If there was patches applied to release, then it would be incremental:

- 16-p-p-1
- 16-p-p-2
- 16-q-q
- 16-q-q-1
- 16-r-r
- 16-r-r-1
- 16-r-r-2
- 16-s-s
- 16-t-t
- 17-u-u
- 17-u-u-1
- 17-v-v
- 17-v-v-1

Applying an annotated tag to a repository would allow a tag-name and a message. We'd then push to the origin without specifying a branch:

```
GIT_TAG="16-s-s"
git tag -a $GIT_TAG -m "Solitary-Snipe released." && git push origin --tags</pre>
```

#### Note on "Sequence"

The tag-name should be "two-digit" year concatenated with "release initials" (ravenous-raven shortens to r-r). Only add an incremented integer if more than one tag for a release is needed.

#### What Should Be Tagged?

The repositories that **should** be tagged for a release are as follows:

- Atmosphere (<<release-name>> branch) - [repo](https://github.com/iPlantCollaborativeOpenSource/atmosphere)
- Troposphere (<<release-name>> branch) - [repo](https://github.com/iPlantCollaborativeOpenSource/troposphere)
- Atmosphere-Ansible (master) - [repo](https://github.com/iPlantCollaborativeOpenSource/atmosphere-ansible)
- Clank (master - maybe a feature-branch) - [repo](https://github.com/iPlantCollaborativeOpenSource/clank)
- nginx_novnc_auth (master) - [repo](https://github.com/cyverse/nginx_novnc_auth)

We should consider tagging this fork
- [https://github.com/edwins/gateone](https://github.com/edwins/gateone)

#### Who Can Tag?

You have to be an admin of a repository to be able to tag releases. Ask an admin to create the tag if you don't have access.

### Release Structure

The structure of releases is inspired by [Chrome/Chromium](http://blog.assembla.com/AssemblaBlog/tabid/12618/bid/36341/Secrets-of-rapid-release-cycles-from-the-Google-Chrome-team.aspx). We aim to deliver new code to production every 5 weeks. Those 5 weeks are split into 3 sprints (2 sprints of 2-weeks and a single 1-week sprint).

#### First 2-week Sprint
- new feature development
- upgrading dependencies
- testing/verification

#### Second 2-week Sprint
- Priority bug fixes
- feature development _continued_
- testing/verification

#### Third 1-week Sprint
- Any committed works left to finish
- Priority/Critical tickets
- testing/verification

### Code Branching Strategy
(Note that the following section contains links to environments that are only accessible to members of CyVerse staff.)

The master branch collects new feature development and community contributions. [http://atmo-dev.cyverse.org](http://atmo-dev.cyverse.org) generally tracks master. Other feature branches are used as needed.

The 'beta' / 'next release' branch collects stability improvements and bug fixes; it does not typically receive new features. [http://atmobeta.cyverse.org](http://atmobeta.cyverse.org/) generally tracks the next release.

Think of each five-week cycle as an effort to 1. develop new features on the master branch, and 2. stabilize the beta/release branch for deployment to production.

Bug fixes and other changes are regularly "trickled down" from the beta/release branch to the master branch, and when necessary, from production systems to beta/release.

Following each release, any changes in the release branch are merged back into master. Then, master is branched into the 'next release' and the cycle repeats.

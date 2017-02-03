# Contributing to Atmosphere

This page is recovering from major surgery (Atmosphere(0)-related content was left on the CyVerse wiki). The broken links will be fixed soon.

This guide is intended to orient community members who are interested in contributing to Atmosphere. Welcome to the project!

## What is Atmosphere?

Atmosphere or 'atmo' can refer to several different things:

- [Atmosphere](https://atmo.cyverse.org/application)(0), CyVerse's "cloud computing for scientists" service
- [Atmosphere](/wiki/display/csmgmt/Atmosphere+Technology+Stack+Overview)(1), **the free, open-source software project** which powers the above service (and is the primary focus of these guides) (TODO fix broken link)
- [Atmosphere](https://github.com/iPlantCollaborativeOpenSource/atmosphere)(2), the API and back-end component of the above software project

For clarity, this page will disambiguate all uses of "Atmosphere".

## Where is Atmosphere Deployed?

Atmosphere(1) is deployed at CyVerse as Atmosphere(0), but also at several other organizations known by different names:

- [Jetstream Cloud](http://jetstream-cloud.org/) (partnership of Indiana University, TACC, & CyVerse - Jetstream GitHub Organization: [jetstream-cloud](https://github.com/jetstream-cloud))
- MOC (Massechusetts Open Cloud) (Jonathan Bell: [github-profile](https://github.com/lokI8), Lucas H. Xu: [github-profile](https://github.com/xuhang57))
- Duke University / Duke Center for Genomic & Computational Biology ([Duke GCB](https://github.com/Duke-GCB)) (Darren Boss: [gcb-profile](https://genome.duke.edu/directory/gcb-staff/darren-boss); [github-profile](https://github.com/netscruff))

## Where is the Code?

### Repositories on Github

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


## Resources and Docs for New Contributors

Familiarize yourself with the following links and use them as a reference.

- [Atmosphere Technology Stack Overview](/wiki/display/csmgmt/Atmosphere+Technology+Stack+Overview) (TODO fix broken link)
- [Atmosphere Troubleshooting Orientation](/wiki/display/csmgmt/Atmosphere+Troubleshooting+Orientation) (TODO fix broken link)
- [Atmosphere(2) API docs on Apiary](http://docs.atmospherev2.apiary.io/)
- [Atmosphere Staff Manual](/wiki/display/csmgmt/Atmosphere+Staff+Manual) containing information on releases  (TODO fix broken link, incorporate that stuff here)
- [Approach to tagging releases](/wiki/display/csmgmt/Approach+to+tagging+releases) (TODO fix broken link)

## Key Terms

You'll hear these a lot on the Atmosphere project:

- _Instance_: a Virtual Machine (VM) or "cloud computer" running on Atmosphere(0) / OpenStack.
- _Image:_ a [disk image](https://en.wikipedia.org/wiki/Disk_image) of a Virtual Machine (with some metadata) from which instances are created.
- _Allocation_: the amount of "CPU time" that a user is allotted, measured in AUs (see below).
- _Allocation Unit_ _(AU)_: "roughly equivalent to using one CPU-hour, or to using one CPU core for one hour." ([source](https://pods.iplantcollaborative.org/wiki/display/atmman/Requesting+More+Atmosphere+Resources)) (TODO fix broken link)
- _Modal_: a [modal window](https://en.wikipedia.org/wiki/Modal_window) in a GUI; the Troposphere UI uses these extensively.

## Testing and Deployment Workflows

### How Atmosphere is Tested

The stack is tested at various levels; test coverage and the testing process is a work in progress.

#### Django tests in Atmosphere(2)

Unit tests written by developers can be found throughout the codebase. These tests are not currently running as part of regular build/deploy workflow, but we could!

#### [Travis CI](https://travis-ci.org/) running style & bundle/compile tests for Troposphere

- see [.travis.yml](https://github.com/iPlantCollaborativeOpenSource/troposphere/blob/master/.travis.yml) in Troposphere for configuration
- [Troposphere test results on Travis CI](https://travis-ci.org/iPlantCollaborativeOpenSource/troposphere)

#### QA Team tests using Robot Framework and JMeter

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

#### [Operation Sanity](https://github.com/cyverse/operation-sanity) behavioral testing

Operation Sanity is a set of test suites written using behave, which drive a browser using Selenium. Operation Sanity exercises common Atmosphere workflows as a user: launches several instances against multiple cloud providers, ensures that those instances launch, creates and attaches volumes, and so forth. It is intended to run these tests in parallel so that long operations (e.g. waiting for an instance to launch) do not block execution.

Operation Sanity is currently in a "proof of concept" state, and is currently not run automatically. There is some intended functionality (e.g. testing launch of Web Shell and Web Desktop) which needs to be built.

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

# Getting Started

We're going to go over some simple terminology and concepts commonly used in Atmosphere.

## Terminology - Atmosphere

### User
A User is an individual that has logged into Atmosphere.
Users have:
- Username (unique)
- Name
- Email

### Group
Groups are used similar to the linux “user/group” model.

- A Group of one will exist for each User.
- A group can contain one or more Users
- Users can be in more than one Group at once
- Groups (not Users) are the “owners” of cloud resources

### Provider
Provider (also known as cloud, cloud provider) is a term used by atmosphere to identify a specific installation of cloud software.
- Providers have a specific set of credentials common to all users (That uniquely identifies them)
    - Ex: auth_url, version, …
- ProviderType
    - Ex: OpenStack, AWS, …
- Providers are owned by a Group (usually a staff/admin)

### Identity
Identities are a term used by atmosphere to identify a specific user on a Provider.
- Identities have a specific set of credentials for the user
    - Example: key(username), secret(password)
- Identities are owned by a Group

### Projects 
Projects (in Atmosphere) represent a collection of Cloud Resources (not sizes) that allow users to logically group related instances/volumes.
- A project is required for new instance/volume created in Atmosphere.
- Projects have a name
- Projects are owned by a Group

### Application
Applications (displayed to the user in troposphere as Image) are a way to abstract a “history” of related Machines (via ApplicationVersion).
Ex:
 | Image Name in OpenStack | Application | ApplicationVersion | ProviderMachines |
 | --- | --- | --- | --- |
 | Ubuntu 16.04 v1 (1111-222-333-4444) | 1 - Ubuntu 16.04 | 1.0 | Tucson Cloud (1111-222-333-4444)|
 | Ubuntu 16.04 v1 (1111-222-333-4444) | 1 - Ubuntu 16.04 | 1.0 | Austin Cloud (1111-222-333-4444)|
 | Ubuntu 16.04 v2 (2222-333-444-5555) | 1 - Ubuntu 16.04 | 2.0 | Tucson Cloud (2222-333-444-5555)|

### ApplicationVersion
ApplicationVersion (also known as Version) is a grouping of one or more Machines.
(In Atmosphere, it is common to replicate a Machine (ex: Ubuntu 16.04) across several Providers (ex: iPlant - Austin, iPlant - Tucson, …).)

Because the image is (mostly) identical across providers, the grouping serves as a way to simplify the cloud-agnostic nature of Atmosphere.
- ApplicationVersions have One or more ProviderMachine
- ApplicationVersions have a name (1.0, 2.0-alpha, beta-do-not-use, …)
- ApplicationVersions have a change log (that helps users understand what changed between versions)

## Terminology - Cloud

### Cloud resource
Cloud Resources are a term used by atmosphere to identify a Volume, Instance, Size, or Machine.

### Size
Sizes (also known as flavors in Openstack) are a preset configuration of CPUs, GB of memory, and Disk space that will be allocated to a Machine when creating an Instance.
Sizes have:
- CPU
- RAM (in GB)
- Disk (for the image, in GB, 0 means "create disk image that is the exact size of the Machine")
- Ephemeral (as an additional mount, in GB)

### Machine
Machines (also known as Image, or ProviderMachine) are like a blueprint that will tell the Cloud how to create a new Instance.
- Machines, minimally, have an operating system
- They may also be installed and configured with additional software applications as desired.
- They are a fixed size (usually 8GB-60GB)
- Administrators and other users can create new machines from Instances via [Machine Requests](#concepts-machine_requests) and/or downloading new image files.

### Volume
Volumes are how users can allocate additional data storage (by policy, up to 1TB) to be used with their instances.
- Volumes have a pre-set size (1-1000gb)
- Volumes start unformatted
    - Atmosphere handles mkfs on first attach + mounting.
- Can be created based on an Image and “Booted” as an instance. (Bootable volumes are not yet a part of atmosphere)

### Instance
Instances (also known as nodes, or servers) is the virtual machine that will be created by end users.
- Instances have a specific size
- Instances are based on an Image or Volume.
- Atmosphere handles the networking and pre-configuration of instances prior to handing control over to the User.

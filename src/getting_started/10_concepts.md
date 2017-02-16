## Concepts in Atmosphere and Openstack

### Concept: Quota and Allocation
Quotas are an admin-set limit on the number of resources a specific cloud user can create at any one time.
- (Ex: Quota of 2 CPU, 8 GB ram)
Allocations are a way for Atmosphere to track the amount of time a specific cloud user has used their resource.
- (Ex: Allocation for 168 hours of compute in one month)

### Conecpt: Machine Requests (Imaging)
When a user launches an instance and configures it to their liking, they can create a MachineRequest that will alert staff users to their desire to create a new Machine.
 Staff members can then accept/reject the request which will start an automated, asynchronous "imaging" process.

During the imaging process:
- The 'machine' is created:
  - Create and Download a snapshot of the Instance
  - Mount and clean the image file to remove “User-specific” data
  - Upload new image to cloud
- The 'machine' is processed:
  - Appropriate metadata is attached to the new image
  - Atmosphere properly catalogs the image into the right Application, Version, and ProviderMachine.
- The 'machine' is validated:
  - Atmosphere will launch the instance and wait for it to go to "green-light active".
  - Atmosphere will then destroy the launched instance
- The 'machine' is completed:
  - The 'machine owner' is e-mailed
  - The machine is ready for launch by others.

### Concept: Projects
Project is an overloaded term, at any one time it could be referring to:
- Atmosphere Project : A collection of Cloud Resources.
- OpenStack “project” aka Tenant: A grouping of users inside OpenStack
- TACC/Xsede project: A collection of TACC/Xsede users.

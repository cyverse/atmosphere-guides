# OpenStack Troubleshooting Guide

This is a collection of OpenStack troubleshooting tips. These are not Atmosphere(1)-specific but may still be useful to operators.

## Instance Troubleshooting

### Launch Instance on Specific Compute Host

You may want to launch an instance on a specific compute host in order to troubleshoot an issue, or change the configuration of nova-compute service on one compute host, and test it.

See this doc from the OpenStack Administrator Guide:
[https://docs.openstack.org/admin-guide/cli-nova-specify-host.html](https://docs.openstack.org/admin-guide/cli-nova-specify-host.html)

### Connect to Instance Console Using Desktop SPICE client

You may want to do this if the SPICE HTML5 client in Horizon is not responding to keyboard input, not refreshing the display, or throwing errors in the text box underneath the video console (e.g. [this behavior](https://forum.opennebula.org/t/4-11-spice-is-not-refreshing/336)). Instead, you can use a GTK client which may not exhibit these bugs.

First, determine the compute host your instance is running on -- Horizon shows you this, or ask the OpenStack CLI `openstack server-show my-instance-uuid`.

Then, SSH to that compute host and look for listening SPICE ports (typically 5900+). Each will be associated with a qemu process. Look for the process containing a `-uuid` argument that matches your instance ID, and read its `-spice` argument -- here it is `port=5900,addr=172.29.236.147`. (I have snipped the very long argument list.)

```
root@marana-17:~# netstat -lntp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 172.29.236.147:5900     0.0.0.0:*               LISTEN      103967/qemu-system-
[snip]
root@marana-17:~# ps aux | grep a6d8d1c5-030a-4989-8914-14909e131887
root       3744  0.0  0.0  14224  1032 pts/2    S+   11:11   0:00 grep a6d8d1c5-030a-4989-8914-14909e131887
libvirt+ 103967  0.0  0.2 9146408 544424 ?      Sl   Apr11   1:15 /usr/bin/qemu-system-x86_64 [snip] -uuid a6d8d1c5-030a-4989-8914-14909e131887 [snip] -spice port=5900,addr=172.29.236.147,disable-ticketing,seamless-migration=on [snip]
```

Here we are using an OpenStack cloud deployed using OpenStack-Ansible, so the process is only listening on the internal management network. We can access this network by creating an SSH connection to the compute host with port forwarding configured:

`ssh -p 1657 -L 5901:172.29.236.147:5900 root@marana-17.cyverse.org`

These instructions were tested using the `spicy` client included with the `spice-client-gtk` APT package. With SSH port forwarding, you can point your local SPICE client to localhost on port 5901; the connection will be forwarded to 172.29.236.147:5900 on the compute host. A graphical console session should be obtained which accepts keyboard input, ctrl+alt+del, etc.

### Inspect the Filesystem of a Running Instance with Broken Networking

To inspect filesystem of an instance that will not accept SSH connections or a console session, you can create a snapshot (image) of that instance, convert that image to a volume, and then attach that volume to another instance.

- Create a snapshot of instance using OpenStack CLI or Horizon UI
    - In OpenStack CLI: `openstack server image create myInstance --name myInstanceSnapshot`

- Convert snapshot (image) to volume in OpenStack CLI ([reference](https://docs.openstack.org/user-guide/common/cli-manage-volumes.html))
  ```
  # Choose an image by its UUID
  openstack image list
  # Note image size for later
  openstack image show deadbeef-dead-dead-dead-beefbeefbeef
  # Choose an availability zone
  openstack availability zone list
  # Create volume, size in GB must be at least as large as the image virtual size (see note below with a *)
  openstack volume create --image deadbeef-dead-dead-dead-beefbeefbeef --size 10 --availability-zone nova my-new-volume
  # Wait for volume to be created, check status with this command
  openstack volume show beefdead-beef-beef-beef-deaddeaddead
  ```

- Attach volume to another working, running instance
  ```
  openstack server add volume myInstance beefdead-beef-beef-beef-deaddeaddead --device /dev/vdc
  ```
  (Ensure that /dev/vdc is not used, increment if necessary)

- SSH to the working instance and mount the filesystem
  ```
  mkdir broken-instance
  mount /dev/vdc1 broken-instance
  ```

Now you can inspect the filesystem, look at the logs, find out what's gone wrong

`*` Volume creation may fail and you see in cinder-volume.log (perhaps on your cinder storage server(s)):
```
ImageUnacceptable: Image 0a23ea76-d661-4483-a562-cba0a3f58a21 is unacceptable: Image virtual size is 20GB and doesn't fit in a volume of size 10GB.
```

https://bugs.launchpad.net/cinder/+bug/1599147
This is fixed but not yet in current stable releases of OpenStack (as of April 2017). Until then, you must look for this error and then specify a larger size when running `openstack volume create`.

## Image Troubleshooting

### Increase the size of a base cloud image

If your flavors/sizes in OpenStack do not have root disks, then you may find yourself restricted by the size of cloud image stored in Glance. If you try to install a GUI or other large software packages then you may quickly run out of disk space.

qcow2 image files (possibly also raw image files) can be resized before they are uploaded to glance using the `qemu-img` command-line tool:

`qemu-img resize xenial-server-cloudimg-amd64-disk1.img +5GB`

This will result in more space available on the root filesystem of instances launched from the image.

(When you increase the size of a compressed qcow2 image using `qemu-img resize`, it may not actually increase the size of the compressed image file.)

### Cannot re-use Glance image UUID? Purge it from Database

atmosphere(1) explicitly sets UUIDs for Glance images, as some deployers wish to maintain consistent matching UUIDs for the same image across multiple OpenStack providers. At some point you may wish to delete a Glance image and re-create it (perhaps so you can upload different image data).

This exposes an issue with Glance: the record of a Glance image (_including its UUID_) persists in the Glance database after the image is deleted, and Glance will not allow you to create a new image with the same UUID as an existing record. (Incidentally, this behavior is [intended](https://bugs.launchpad.net/glance/+bug/1176978) by the Glance developers.)

```
MariaDB [glance]> select id, name, status from images where id = '948cf114-dfd7-4e2d-b84f-9bf6dab47aa3';
+--------------------------------------+--------------------------------+---------+
| id                                   | name                           | status  |
+--------------------------------------+--------------------------------+---------+
| 948cf114-dfd7-4e2d-b84f-9bf6dab47aa3 | Trinotate_RNAseq_annotation_v3 | deleted |
+--------------------------------------+--------------------------------+---------+
```

Fortunately, there is a Glance [db purge utility](https://specs.openstack.org/openstack/glance-specs/specs/mitaka/implemented/database-purge.html) which will remove records from all deleted images, so we can re-use their UUIDs.

First, get a shell to your Glance server (or container).

If you have just deleted your image (less than 1 day ago), you must comment out the following two lines in glance/cmd/manage.py (as of OpenStack Newton release):

```
# diff glance/cmd/manage.py.bak.20170620 glance/cmd/manage.py
160,161c160,161
<         if age_in_days <= 0:
<             sys.exit(_("Must supply a positive, non-zero value for age."))
---
>         # if age_in_days <= 0:
>         #     sys.exit(_("Must supply a positive, non-zero value for age."))
```

Now, run the purge utility. If Glance is installed in a virtual environment, activate it first (e.g. `source /openstack/venvs/glance-14.0.4/bin/activate`), then run the following:

```
# glance-manage db purge --age_in_days 0
```

You should now be able to re-create a Glance image with the same UUID as a previous image.

This will take you through how to create a machine request in Troposphere.

# Imaging and Machine Requests

An image is a type of template for a virtual machine.

Images are created by launching an instance, installing the software and files that you want to use, and creating a Machine Request.
After the image is created, you will be able to launch instances of it. This makes it easier to create reproducible science or distribute commonly used software to other users.

Images save resources, since you can relaunch an instance of your image at any time instead of having to keep the instance running when you don't need to use it.

After submitting your form, the support staff may review your submission and ask for additional information before approving the request.

Advanced functionality optionally included in your Machine Request:
* Include 'Licensing' information that will inform users intending to launch your image what is implied and agreed upon.
* Include 'Boot Scripts' that will allow you to make changes for each user who launches your image at run time. (For example: To update the permissions to the launching user)

# Before you create your machine request!

These steps must be completed in order to ensure the image that is created is compatible with Atmosphere:
* Remove any non-purchased, licensed software that does not allow for free and open use in the cloud.
* Software in which the licensing otherwise prevents the use within a cloud or virtualized environment.
* Do *NOT* install software in these directories, as they will be destroyed during the imaging process:
* * /home/ - All files, directories, and icons located under /home/<username>/Desktop will be deleted. To preserve them, you can use /etc/skel which is the directory that will be *COPIED* to *each new user* of the VM. Note that these should be small files or starter directories.
* * /mnt
* * /tmp
* * /var/log - All files and directories will be *emptied* but not destroyed, as part of the imaging process.
* * /root - All files and directories under /root/ will be destroyed as part of the imaging process.
* Volumes will *NOT* be copied to a new image. The files must exist on the disk.
* Modifications to these files will be destroyed as part of the imaging process:
* * /etc/fstab
* * /etc/fstaf
* * /etc/group
* * /etc/host.allow
* * /etc/host.conf
* * /etc/host.deny
* * /etc/hosts
* * /etc/ldap.conf
* * /etc/passwd
* * /etc/resolve.conf
* * /etc/shadow
* * /etc/sshd/
* * /etc/sysconfig/iptables
* If you install software that logs *outside* of /var/log, be sure to *empty the file* especially if it contains secrets or otherwise confidential information about your account *prior* to making a Machine Request for imaging.
* NOTE: The permissions of the operating system are NOT affected by the imaging process.
  If you install software as
  `username:groupname`
  and you intend to provide that software to other users who launch your image, you will need to *include a Boot Script* that will change the permissions of the directory.

# Creating a Machine Request

1. Click Projects on the menu bar and open the project with the instance to use for the new image.
3. Click the instance name. The instance must be in Active status.
3. In the Actions list on the right, click Image.
4. On the Image Request form, enter the necessary information:
  + New Image Name: Enter the name, up to 30 characters, to assign to the new image.
  + Description of the Image: Enter the description of the image as it will appear in Atmosphere. The description should include key words that concisely describe the tools installed, the purpose of the tools (e.g., This image performs X analysis), and the initial intent of the machine image (e.g. designed for XYZ workshop).
  + Image Tags: (Optional) Click in the field and select tags that will enhance search results for this image. You can add and remove tags later, if needed.
5. Click Next.
6. In the second screen:
  + New Version Name: Enter the new (unique) name or number of the tool to distinguish this tool from others with a similar name.
  + Change Log: Enter a brief description of the changes you made to this version of the tool.
7. Click Next.
8. In the Cloud for Deployment screen: 
  + Select the cloud provider to use for the image. The choices depend on the providers to which you have been granted access.
9. Click Next.
10. In the Image Visibility screen:
  + Select the visibility for the image. 
  + Public: Makes the image visible to and launchable by everyone.
  + Private: Allows only you to view and launch the image.
  + Specific Users: Makes the image visible to and launchable only specified users.
    If you chose Specific Users, select the users who will be able to launch the image.
11. To access advanced options, including excluding directories from the image, adding deployment scripts that execute when the image is launched or the status changes, or requiring the user to verify understanding of any license restrictions, click Advanced Options:
12. To exclude files from the image, list each file to exclude on a separate line and then click Next. (This step is optional. To skip this step, just click Next.)
13. To add a deployment script, click in the search field and search for the title of the script.
  + To create a new deployment script:
    * Click Create New Script, enter a title for the script, and then either click URL and enter the URL to the script, or click Full Text and enter the deployment script.
      + URL Option: URLs must start with http[s]://
      + Full Text Option: It is expected that your script will include a shebang line ex: #!/bin/bash
    * When done, click Create and Add, and then click Next. (Just click Next to continue to the next screen without adding a new script).
14. To list any licensed software used in the image and require users to agree to the license agreement before launching, click in the search field and search for the license title.
  + To create a new license:
    * Click Create New License, enter a title for the license, and then either click URL and enter the URL to the license, or click Full Text and enter the full license text.
    * When done, click Create and Add, and then click Next. (Just click Next to continue to the next screen without adding a new script).
15. In the Review screen, click the checkbox certifying that the license does not contain any license-restricted software.
16. Click request image.

# Viewing your Machine Requests

In the current UI, you can view your lists of images and image requests.

1. In the Atmosphere current UI, click Images on the top menu bar.
2. Click My Images tab at the top of the screen.

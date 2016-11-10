## Troubleshooting common errors on Instance Launch/Deployment

## The Problem: After completing the launch instance dialog, the instance immediately goes to `error` state.
In most cases, the "Error" state is the result of a problem on the backend cloud provider.

Triaging an instance in the error state:
* Use the nova CLI tools to determine the `fault` message on the instance by running these commands:
```
nova show <instance_id>
```
* Lookup the fault message below and determine the appropriate solution. 
  If no obvious solution can be found, see [Contacting the Atmosphere Team](#)


Common reasons the cloud may launch an instance in error:
- Build Scheduling Failed: No host could be found:
  - These errors appear when the cloud is nearing capacity.
  - If the instance flavor/size launched was "large" you can try a smaller size and see if the error persists.
  - If the smaller size launches, your cloud is likely full. Contact the Cloud System Administrator to be sure.

## The Problem: Instance is "stuck" in `networking`

Note that we define 'stuck' as being in the state for >20 minutes, but for some older clouds it can take as long as 2 hours to move from `networking` to `deploying`.

An instance will be stuck in networking if one of the following conditions is true:

- The instance was recently launched and has not yet completed the 'boot' process. These instances are *offline*
- The instance was recently assigned a floating IP and it has not yet "stuck" to the instance. These instances are *not reachable via SSH*
- The instance is *online* and *reachable via SSH*, but the SSH key did not properly deploy to the instance on first boot.
- If after >2 hours, one of these three conditions is still resulting in failure, the instance will move to [deploy_error](#deploy_error).

1. A common resolution to an instance stuck in networking is to reboot it from the Tropospere UI while [emulating](#) as the user experiencing the issue. 
   If the instance gets stuck in networking again, proceed to step 2.
2. If an instance is stuck in networking, you can check [flower](#) to see current celery tasks and find the instance in question. 
   If there is an error, flower will display it and you can diagnore the issue from there. 

## The Problem: Instance is "stuck" in `deploying`
When an instance has made it to `deploying` it is an indication that Ansible code is being run on the device via SSH.

Instances that are in `deploying` should be diagnosed with [flower](#) to see if there is a task currently being run on the instance.
If an error is encountered, the task will be retried. Ansible will try a few times to get a 100% success from the list of playbooks.

If it cannot do so, then the instance will be moved to the final state: `deploy_error`.
If the instance goes to `deploy_error`, see [Contacting the Atmosphere Team]() to provide a fix for the instance.
Once a hotfix is in place, the user should be [emulated](#) and then the instance should be `re-deployed` so that the instance will make it to green-light active and the user can begin their work.

## Resolving an instance that is stuck in `deploy_error`
<a name='deploy_error'></a>
1. In the case of a deploy error, the most common course of action is to emulate as the user facing the issue and click the "Redeploy" button from the instance in question's detail page. If the instance reaches another deploy error, move on to step 2.
2. In some cases, a reboot of the instance will resolve a deploy error. You can try rebooting the instance from the instance's detail page by clicking on the "reboot" button. If for some reason a soft reboot fails, try a hard reboot. If the instance comes back to deploy error, move on to step 3.
3. Check the [deploy logs](#logs) and look for the instance ID to see the output of which specifc tasks failed. From here, you can try to resolve the issue manually and redeploy. To easily check the realtime status of an instance's deploy process, you can use `tail -f <deploy_log_file> | grep <instance_alias>`

## Contacting the Atmosphere Team
* You will likely need to contact the system administrator of the cloud and/or the atmosphere team for futher intervention.
Please be sure to provide this information **at a minimum** to ensure your request can be answered in a timely fashion:
```
Username:
Instance ID:
IP Address:
Cloud Provider:
Image/Application selected: (UUID of ProviderMachine would be great, too)
Size selected:
Fault message from nova:
Additional notes from triage:
```
This information will allow more advanced users to reproduce your problem and find a solution without contacting you a second/third time.


## Argo Workflow

### What is Argo
Argo Workflows is an open source container-native workflow engine for orchestrating parallel jobs on Kubernetes.

### Why Argo
Argo will eventually be replacing celery in Atmosphere. It offers more visibility into the tasks that used to performed by celery.

### Usage in Atmosphere

As of Atmosphere `v37-0`, Argo is only used for instance deployment.

#### Instance Deployment
- Instead of running the deployment ansible playbooks as a celery task, an Argo workflow is created to run the ansible playbooks.

- There will be one step in the workflow for each playbook.

- The creation and polling for the workflow is done in the same place in a celery task.

- Necessary arguments are passing to the workflow when it is created.

- There are 3 levels of retries
    1. the ansible retry, but only for tasks that defines it (usually package install)
    2. the workflow step retry, if a step in the workflow fails, it will be retried up to a certain times as defined in the workflow definition
    3. the celery retry, since the creation and polling of the workflow are still part of a celery task, celery task retry still applies here, and this retry will submit a new workflow to Argo each time.

- Deployment logs for a workflow are located at `/opt/dev/atmosphere-docker/logs/atmosphere/atmosphere_deploy.d/<USERNAME>/<INSTANCE_UUID>/<DEPLOYMENT_DATE_TIME>/` on the host. Each steps/nodes in the workflow will have its own log file in the directory. The logs here are pulled after the workflow is completed (not realtime).
> Note: only logs for playbooks that run in Argo Workflow are in those directories, the logs for other playbooks remain where they were.

### Troubleshooting

- Most troubleshooting will be done via `argo` cli and `kubectl`.

#### List workflows
```bash
argo list -n <NAMESPACE>
```

```bash
argo list -n <NAMESPACE> --status <WORKFLOW_STATUS> --since <DURATION>
```

#### Find Workflow Name for a deployment
As of `v37-2` there isn't a convenient way to lookup workflow name in real time other than check the parmeter of individual workflows, and look for username and the IP of the instance.
However the workflow name will be part of the log filename that gets pulled after workflow completes, e.g. `ansible-deploy-xxxxx.log`

#### Get details of a workflow
```bash
argo get -n <NAMESPACE> <WORKFLOW_NAME>
```

get the workflow definition as YAML
```bash
argo get -n <NAMESPACE> <WORKFLOW_NAME> -o yaml
```

#### Get logs of a workflow (all pods within the workflow)
```bash
argo logs -n <NAMESPACE> <WORKFLOW_NAME>
```

`-f` to follow the logs
```bash
argo logs -n <NAMESPACE> <WORKFLOW_NAME> -f
```

#### Get logs of a pod
Each pod in an argo workflow will usually consist of 2 containers, `main` and `wait`, `main` container will be the one that executes the actual workload.
```bash
kubectl logs -n <NAMESPACE> <POD_NAME> main
```

`-f` to follow the logs
```bash
kubectl logs -n <NAMESPACE> <POD_NAME> main -f
```

#### Resubmit a workflow
There is a command that will resubmit a workflow with the exact workflow definition and parameters.
```bash
argo resubmit -n <NAMESPACE> <WORKFLOW_NAME>
```


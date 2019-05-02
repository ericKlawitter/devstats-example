#Knative Devstats Site

[Devstats](https://github.com/cncf/devstats) is an open source project used for
collecting metrics for GitHub project(s). Knative has a site running on GKE
which is used for viewing these metrics. The directory contains manifests for
running Devstats on a Kubernetes Cluster.

##Components
- NFS mount: We use an NFS mount for storing so that the back and cron jobs have
  a consistent location to pull from.
- Postgres: The database used for storing metrics.
- Grafana: The front end for displaying dashboards. Grafana reads from the Postgres database. Dashboards are defined in the [grafana/dashboards](grafana/dashboards/knative/) directory.



##Installing Devstats on Kubernetes
**See [devstats-example](https://github.com/cncf/devstats-example) for configuring devstats for the repo of your choice**
1. Create a Kubernetes cluster and an nfs. The NFS should be configured your Kubernetes/nfs_pvc.yaml file.
1. After configuring your project settings, run scripts/k8s_objects.sh - this
   will create the k8s objects required to build the devstats database.
1. Run kubectl exec -it devstats-cli-0 /bin/bash to execute commands from the CLI. From here we will run commands to initialize the devstats binaries.
1. Run the following scripts. These will create the devstats tags and
   annotations.
  1. scripts/setup_db.sh
  1. scripts/setup_mount.sh
  1. /mount/data/src/devstats/shared/tags.sh
  1. /mount/data/src/devstats/annotations
1. Exit out of the pod and run kubectl create -f Kubernetes/backfill.yaml. This creates the job to backfill the database with the github archive data. After that job finishes (it takes a few hours), run kubectl create -f Kubernetes/cron.yaml. This creates the hourly job to update the database.
1. Run kubectl create -f Kubernetes/grafana_service.yaml. This will create the
   Grafana front end service. You can run `kubectl get service` to view the
   external IP for the service. You will need to manually set up the Grafana
   front end.
1. 

#Knative Devstats Site

[Devstats](https://github.com/cncf/devstats) is an open source project used for
collecting metrics for GitHub project(s). Knative has a site running on GKE
which is used for viewing these metrics. The directory contains manifests for
running Devstats on a Kubernetes Cluster.

##Components
- NFS mount: We use an NFS mount for storing so that the back and cron jobs have
  a consistent location to pull from.
- Postgres: Postgres is the backend database used for storing knative metrics.
  Devstats creates a database called `knative` (the name of the GitHub project),
  which stores all metrics. Consult the [devstats documentation](https://github.com/cncf/devstats/blob/master/USAGE.md#database-structure) for database schema information.
- Backfill Job: A backfill job is ran once on creation to populate the database
  initially. This script can take a few hours. After it runs initially, the cron
  job populates the devstats going forward.
- Cron Job: We run devstats hourly through a cron job. This will poll metrics for all
  Knative repos and update the database accordingly.
- Grafana: The front end for displaying dashboards. Grafana reads from the Postgres database. Dashboards are defined in the [grafana/dashboards](grafana/dashboards/knative/) directory.
- Home Pod: We allocate a home pod for initial installation. This home pod is
  responsible for configuring the mounted NFS volume and setting up the database
  properly. See [the installation instructions](INSTALL.md) for more
  information.


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

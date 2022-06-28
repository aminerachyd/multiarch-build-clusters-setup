# OpenShift multiarchitecture build using Tekton - clusters setup

<!-- TODO Change the repo to the IBM org -->

This Terraform script is an automated setup for building multiarchitectures images using Tekton on different OpenShift clusters.

The pipelines used are under the repository : https://github.com/aminerachyd/ibm-garage-tekton-tasks

The multiarchitecture pipelines build images for x86, IBM Z (s390x) and IBM Power (ppc64le) architectures.

## Pre-requisites :

- Terraform CLI installed
- Admin access to two x86 clusters, a Z cluster and a Power cluster
- One x86 cluster is used as a development cluster, the [Cloud-Native Toolkit](https://cloudnativetoolkit.dev/) should be installed on this cluster. The other clusters will be used as "workload clusters" to build images in the corresponding architectures.

## Variables :

`project-name` is the name of the project you want to create. The script will generate a project named `<project-name>-dev` on the development cluster in which you can run your pipelines.

The script will create on each workload cluster 3 projects : `<project-name>-dev`, `<project-name>-test` and `<project-name>-prod`, the first for running a remote pipeline, and the other two for deploying the applications in test and production environments.

### Cluster hosts :

`dev-cluster-host`, `x86-cluster-host`, `power-cluster-host` and `z-cluster-host` are variables holding the hosts of the clusters; these will be pointing to API servers of the clusters. Note that the `dev-cluster` is an x86 cluster that should have the Cloud-Native Toolkit installed.

### Cluster tokens

`dev-cluster-token`, `x86-cluster-token`, `power-cluster-token` and `z-cluster-token` are variables holding the tokens of the clusters; these will be used to authenticate to the clusters. Note that this setup requires cluster admin access.

### Image registry access

`registry-user` and `registry-token` are variables holding the user and token to the image registry in which the images will be stored. Terraform will create on all clusters (on the dev projects) a secret called `docker-registry-access` that will hold the credentials.

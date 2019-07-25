# deploying-with-terraform
Simplifying configuration and deployment of multi-tenant environments with GitOps and Terraform

# Prereqs

* gcloud account
* gcloud SDK setup
* terraform and helm installed
* GCloud
    * Project Created
    * terraform SA with "Owner"
    * export GOOGLE_APPLICATION_CREDENTIALS=../tf-cred.json

# Terraform Modules

## gcp-project-init

* create k8s cluster

### Issues

* If you get API not enabled errors running terraform, follow the instructions in the error to enable the appropriate APIs

## deploy

* create service account
* create k8s namespace
* create k8s secret
* rocketchat maybe? - https://github.com/helm/charts/tree/master/stable/rocketchat


# Notes
export GOOGLE_APPLICATION_CREDENTIALS=../tf-cred.json
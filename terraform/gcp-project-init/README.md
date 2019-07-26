# GCP Project Init

_**Disclaimer:** This Terraform code is intended for quick demonstration purposes only. It is not production-ready and takes many shortcuts on things like security, testing, reusability, etc. Additionally it does not soley use "free tier" resources and will charge your account for usage._

This code is meant as a simple way to bootstrap a demo Kubernetes environment in GCP. After running, you will have a k8s cluster with a single node pool, helm initialized, and the nginx ingress controller deployed as a Load Balancer service.

## Prereqs

* Active GCP Account (start with $300 credit if you haven't used it before)
* Setup GCloud SDK in your environment
* Install following in your environment
    * Terraform 
    * Helm installed
    * jq (used often when using external data providers in Terraform)
* GCP Project Created
    * Any name you want, you will need the Project ID when you run Terraform
* Terraform service account within Project
    * Create new service account "terraform" with "Owner" permissions
* Setup [Application Default Credentials](https://cloud.google.com/docs/authentication/production)
    * Download JSON keyfile for terraform service account
    * export GOOGLE_APPLICATION_CREDENTIALS={path_to_json}

## Parameters

You can provide parameter inputs when prompted, on command line, or by creating a tfvars file.

| Variable             | Description                                                                      | Default       |
|----------------------|----------------------------------------------------------------------------------|---------------|
| project_id           | GCP Project ID                                                                   | N/A           |
| region               | Desired GCP Region                                                               | us-central1   |
| zone                 | Desired GCP Zone                                                                 | us-central1-a |
| k8s_cluster_name     | Name of k8s Cluster                                                              | demo-cluster  |
| k8s_node_count       | Number of nodes in Node Pool                                                     | 2             |
| Master Authorized IP | IP Address of your environment. Required to communicate with k8s master cluster. | N/A           |

## Running It

_Note:_ If you get API not enabled errors running terraform, follow the instructions in the error to enable the appropriate APIs and re-run it.

```
terraform init
terraofrm plan
# Verify plan
terraform apply
```

## Outputs

| Output                 | Description                         |
|------------------------|-------------------------------------|
| cluster_endpoint       | IP of master cluster endpoint       |
| nginx_ingress_endpoint | IP Address of Ingress Load Balancer |

## Cleanup

```
terraform destroy
```
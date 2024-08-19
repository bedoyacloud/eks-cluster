## Prerequisites

Install Terraform on you OS
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

Install aws cli
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

Install Python3
https://www.python.org/downloads/

Install kubectl locally
https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

remember to  - aws configure with the access key credentials with enought permissions to create and manage the EKS Cluster

# Django Pizza Project

I was able to deploy the Django app into the AWS EKS Cluster
I attach this images as support

![Image-Support](https://github.com/bedoyacloud/eks-cluster/blob/main/django-app-on-aws-eks.png?raw=true)


## Clone Repo
[You can clone the repo from]([URL](https://github.com/bedoyacloud/eks-cluster/tree/main))


## Overview

This project is a Django-based web application for managing pizza orders. The application is containerized using Docker and deployed on a Kubernetes cluster using Helm. The primary focus of this project is to demonstrate how to build, containerize, and deploy a Django application in a cloud environment.

## Project Structure

```
├── Dockerfile
├── helm
│   └── django-pizza
│       ├── Chart.yaml
│       ├── templates
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   └── ingress.yaml
│       └── values.yaml
├── app
│   ├── manage.py
│   ├── pizza_project
│   │   ├── settings.py
│   │   ├── urls.py
│   │   └── wsgi.py
│   └── orders
│       ├── models.py
│       ├── views.py
│       └── urls.py
└── README.md
```

## Docker Setup

1. **Building the Docker Image:**

   To build the Docker image for the Django application, run:

   ```bash
   docker build -t carloscloud/django-pizza:v2 .
   ```

2. **Pushing the Docker Image:**

   After building the image, you can push it to your Docker Hub or image container registry:

   ```bash
   docker push dockerhub-user-id/django-pizza:v2
   ```
--------------------------------------------------------------------
## AWS EKS Kubernetes Deployment

```
├── README.md
├── eks.tf
├── helm.tf
├── main.tf
├── providers.tf
├── terraform.tfstate
├── terraform.tfstate.backup
├── variables.tf
└── vpc.tf
```

1. **Creating the Kubernetes Cluster:**

   Create a Kubernetes cluster on AWS EKS or any other cloud provider.

   When you want to create the infrastructure with terraform, once you had clone it,
   you can cd to terraform folder and run the commands:

```bash
export EKS_CLUSTER_NAME=eks-mvp-django
```

```bash
terraform init
```

```bash
terraform apply -var="cluster_name=$EKS_CLUSTER_NAME" -auto-approve
```
Once terraform has sucessfully deploy the AWS EKS Cluster
You have to configure context:

```bash
aws eks --region us-west-2 update-kubeconfig --name eks-mvp-django
```

## Destroy - In case you need to destroy the EKS cluster
```bash
terraform destroy -var="cluster_name=$EKS_CLUSTER_NAME" -auto-approve
```

2. **Deploying with Helm:**

   Use the Helm chart provided in the `helm/django-pizza` directory to deploy the Django application:

   ```bash
   helm install django-pizza helm/django-pizza
   ```

   To update the release after making changes:

   ```bash
   helm upgrade django-pizza helm/django-pizza
   ```

## Troubleshooting

1. **Common Issues:**

   - **DisallowedHost Error:** Ensure that the ELB hostname is added to the `ALLOWED_HOSTS` in the Django `settings.py`.
   - **Helm Upgrade Timeout:** If a Helm upgrade takes too long, check for issues in the Kubernetes cluster, such as resource limits or network issues.

2. **Checking Logs:**

   To view the logs of the Django application:

   ```bash
   kubectl logs <pod_name> -n <namespace>
   ```

## Conclusion

This project serves as a template for deploying a Django application using Docker, Kubernetes, and Helm. It demonstrates best practices in containerization and cloud deployment, making it a great starting point for more complex projects.

## Documentation I used:

https://github.com/aws-ia/terraform-aws-eks-blueprints

https://github.com/aws-samples/eks-workshop-v2/blob/main/cluster/terraform/variables.tf

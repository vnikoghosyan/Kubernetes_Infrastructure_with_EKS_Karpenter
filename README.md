# Kubernetes Infrastructure with EKS and Karpenter

This project provisions an Amazon EKS cluster with Karpenter for autoscaling, utilizing Terraform for infrastructure as code. The setup supports ARM64 (Graviton) and x86 workloads.

## Prerequisites
1. Terraform: Install Terraform v1.0+ [here](https://developer.hashicorp.com/terraform/install) or [here](https://tfswitch.warrensbox.com/Installation/).
2. AWS CLI: Install AWS CLI v2 [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
3. kubectl: Install kubectl [here](https://kubernetes.io/docs/tasks/tools/).
4. IAM Permissions:
    - Ensure you have appropriate AWS permissions to create resources (VPC, EKS, IAM roles, and S3 bucket if backend is configured).

## Directory Structure
```
├── main.tf                  # Root Terraform configuration
├── modules                  # Reusable Terraform modules
│   ├── eks                  # EKS module
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── karpenter            # Karpenter module
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── vpc                  # VPC module
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf               # Root output configuration
├── terraform.tfvars         # Input variable definitions
└── variables.tf             # Input variable schema
```

## Steps to Deploy the Infrastructure
1. Clone the Repository
```
git clone <repository-url>
cd <repository-directory>
```
2. Configure Terraform Variables

Edit the terraform.tfvars file to match your environment:
```
aws_region           = "us-west-2"
cidr_block           = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
cluster_name         = "my-cluster"
cluster_version      = "1.31"
```
3. Initialize Terraform

Initialize the Terraform project to install providers and link modules:
```
terraform init
```
4. Plan the Infrastructure

Preview the changes Terraform will apply:
```
terraform plan
```
5. Apply the Configuration

Deploy the infrastructure:
```
terraform apply
```
6. Access the EKS Cluster

Export the kubeconfig for the created cluster:
```
aws eks --region us-west-2 update-kubeconfig --name my-cluster
```
Verify the cluster is accessible:
```
kubectl get nodes
```
7. Deploy Karpenter Provisioner

After Karpenter is deployed, create a provisioner to manage workloads:
```
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: default
spec:
  requirements:
    - key: "kubernetes.io/arch"
      operator: In
      values:
        - amd64
        - arm64
  provider:
    subnetSelector:
      karpenter.sh/discovery: my-cluster
    securityGroupSelector:
      karpenter.sh/discovery: my-cluster
  ttlSecondsAfterEmpty: 30
```
Save this YAML as ```provisioner.yaml``` and apply it:
```
kubectl apply -f provisioner.yaml
```
8. Deploy a Test Workload

Deploy a workload to validate autoscaling:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```
Save this YAML as ```nginx-deployment.yaml``` and apply it:
```
kubectl apply -f nginx-deployment.yaml
```
Verify the pods:
```
kubectl get pods
```

## Outputs
After applying Terraform, you will see the following outputs:
- VPC ID
- Public Subnets
- Private Subnets
- EKS Cluster Name
- EKS Cluster Endpoint

## Improvements
### 1. Configure Terraform Backend

To ensure state file consistency and team collaboration, configure the Terraform backend to use an S3 bucket.
#### Steps to Enable S3 Backend
1. Create an S3 Bucket
```
aws s3api create-bucket --bucket my-terraform-state --region us-west-2
```
2. Create a DynamoDB Table for State Locking
```
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1
```
3. Update ```main.tf``` Add the following block to that file:
```
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "eks-cluster/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```
4. Reinitialize Terraform After adding the backend configuration, reinitialize Terraform:
```
terraform init
```
### 2. Additional Improvements
- Enable Detailed Logging: Enable detailed CloudWatch logging for debugging purposes.
- Security Enhancements:
    - Restrict S3 bucket access for the state file.
    - Use KMS for EKS secrets encryption.
- Scaling Configurations: Fine-tune scaling policies in the provisioner based on workload patterns.
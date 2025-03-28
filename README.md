# Terraform EKS Cluster with Karpenter

This Terraform project provisions an Amazon Elastic Kubernetes Service (EKS) cluster and integrates it with Karpenter for automated and efficient node provisioning.

## Prerequisites

Ensure the following tools and configurations are in place before proceeding:

- **AWS Account**: Active AWS account with necessary permissions.
- **Terraform**: Installed and configured (>= v1.5.7).
- **AWS CLI**: Installed and configured (>= 2.25.2).
- **kubectl**: Installed (>= 1.32).

## Getting Started

### 1. Clone the Repository

Clone this repository to your local machine:

```bash
git clone git@github.com:kbabuadze/ops-terraform.git
cd ops-terraform
```

### 2. Configure AWS Credentials

Set up your AWS credentials using one of the following methods:

**Option A: Environment Variables**

```bash
export AWS_ACCESS_KEY_ID=<your_access_key_id>
export AWS_SECRET_ACCESS_KEY=<your_secret_access_key>
export AWS_REGION=<your_aws_region>
```

**Option B: AWS CLI Configuration**

```bash
aws configure
```

### 3. Provide Variables

Copy the example `.tfvars` file and update it with the required values:

```bash
cp .tfvars.example .tfvars
```

- Ensure to provide values for `vpc_id` and `subnet_ranges`.

### 4. Apply the Configuration

Review the planned changes before applying them:

```bash
terraform plan
```

Initialize Terraform and apply the configuration:

```bash
terraform init && terraform apply --var-file=.tfvars
```

## Resources Provisioned

The following resources will be created:

- An EKS cluster across specified availability zones.
- Two managed nodes for critical workloads, including Karpenter.
- Karpenter resources and workloads.
- EC2NodeClass and NodePool configurations.

## Usage

### Access the Cluster

Retrieve the kubeconfig for your cluster. By default, the configuration is written to `.kube/config`. To specify a different path, refer to the [AWS CLI documentation](https://docs.aws.amazon.com/cli/latest/reference/eks/update-kubeconfig.html):

```bash
aws eks update-kubeconfig --region <your_region> --name ops-eks-cluster
```

### Trigger Scaling with Karpenter

Example resources for testing Karpenter's scaling capabilities are available in the `./examples` directory. Apply them using:

```bash
kubectl apply -f examples/<file.yaml>
```

Karpenter will automatically scale up the most suitable resources based on workload requirements. For more details, visit the [Karpenter documentation](https://karpenter.sh/docs/).

### Specify Node Types

To target specific instance types (e.g., ARM nodes or Spot instances), use `nodeSelector`. Examples are provided in the `./examples` directory:

- `nginx.deploy.capacity.yaml`
- `nginx.deploy.arm64.yaml`

Apply these configurations as needed to customize your workloads.


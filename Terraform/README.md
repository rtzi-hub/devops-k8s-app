# Build Your Infrastructure With Terraform 🚀

## Overview
This Terraform configuration provisions an **AWS infrastructure** to deploy a **Kubernetes cluster** with **Minikube**, a **MongoDB instance**, and a **Node.js application**.

---

## 1️⃣ Prerequisites
Before running this Terraform script, ensure you have the following installed:

- **Terraform** (for infrastructure provisioning)
- **AWS CLI** (for AWS authentication)
- **An AWS account with access credentials configured**
- **A key pair** (`.pem` file) for SSH access to the EC2 instance

---

## 2️⃣ Clone the Repository
Run the following command to clone the project:

```bash
git clone https://github.com/rtzi-hub/devops-terraform.git
cd devops-terraform
```

---

## 3️⃣ Configure AWS Credentials
Ensure your AWS credentials are set up:

```bash
aws configure
```
Enter Your Access Key, When Requested.
---

## 4️⃣ Initialize Terraform
Initialize Terraform to download required providers and modules:

```bash
terraform init
```

---

## 5️⃣ Plan the Infrastructure
Run the following command to preview the infrastructure changes before applying them:

```bash
terraform plan
```

---

## 6️⃣ Deploy the Infrastructure
To apply the Terraform configuration and deploy resources:
(Auto approve command will create your infrastructure instantly)
```bash
terraform apply -auto-approve
```

This will:
✔️ Create a **VPC**  
✔️ Create a **Public Subnet**  
✔️ Set up an **Internet Gateway & Route Table**  
✔️ Deploy an **EC2 Instance** for **Kubernetes**  
✔️ Configure **Security Groups**  
✔️ Install **Minikube, Helm, Docker, and Kubernetes CLI**  

---

## 7️⃣ Get the Public IP of the Kubernetes Server
To retrieve the public IP of the EC2 instance:

```bash
terraform output k8s_server_ip
```

Use this **IP address** to SSH into your EC2 instance:

```bash
ssh -i <Your-Key.pem> ubuntu@<k8s_server_ip>
```
You will see the Public IP in the outputs
---

## 8️⃣ Destroy the Infrastructure (Cleanup)
To remove all AWS resources when you are done:

```bash
terraform destroy -auto-approve
```
If you want to reveal the outputs again use the command.
```bash
terraform output
```
---

## 📌 Notes
⚠️ **Security Warning:** The security group allows SSH and application traffic from all IPs (`0.0.0.0/0`). Restrict access if needed.  
⚠️ **Ensure you replace** `<Your-Key.pem>` with your actual AWS **key pair** name in the Terraform file.  

---

## 🚀 Enjoy Your DevOps Kubernetes Deployment! 🚀


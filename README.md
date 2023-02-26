# ITI-Graduation-Project

## Brief

---

### 1. Fully Automated CI/CD Using Jenkins

### 2. Deployed on AWS EKS Cluster

### 3. Configured by Ansible and Terraform

---

## Requirements

Deploy the backend application on a Kubernetes cluster using a CI/CD Jenkins pipeline, using the following steps and high-level diagram:

1. Implement a secure Kubernetes Cluster
2. Deploy and configure Jenkins on Kubernetes
3. Deploy backend application on Kubernetes using Jenkins pipeline

![Architecture Diagram](./ProofOfWork_ScreenShots/Archietecture.jpg)

---
## Terraform

Creating full infra :

- Networks: VPC, Subnets, NATs, IGW (4 subnet existed to give the option to create Internal and External LBs)
- EKS Cluster, Node Group
- Jumphost Machine to control the EKS from the inside of the VPC
- <https://github.com/MMamdouh996/ITI-Graduation-Project>

## Ansible

Terraform executes Ansible, which:

- Configures the Node Instances
- Configures Jumphost machine
- Deploys (kubctl) namespaces, ServiceAccount, Role, Role Binding, Jenkins Deployment, Kubernetes service (ELB) to access the Jenkins

## Jenkins

Listens to a specific repo and applies CI/CD to the required App.

- <https://github.com/MMamdouh996/lexalyzer>

## Github Actions

To Dockerize the Jenkins base image and the required packages to be deployed and used on Kubernetes.

- <https://github.com/MMamdouh996/jenkins-image-builder>

---

# Here is the running Process

## 1. Creating Bucket and dynamoDB table to handle tfstate file and lockstate
![Architecture Diagram](./ProofOfWork_ScreenShots/02.png)
![Architecture Diagram](./ProofOfWork_ScreenShots/03.png)

## 2. Applying of terraform Code
![Architecture Diagram](./ProofOfWork_ScreenShots/01.png)
## 3. Terraform provisioning wiht ansible
![Architecture Diagram](./ProofOfWork_ScreenShots/04.png)
## 4. IaC finished succesful
![Architecture Diagram](./ProofOfWork_ScreenShots/05.png)
## 6. EKS Cluster from Console
![Architecture Diagram](./ProofOfWork_ScreenShots/06.png)
## 7. s3 bucket for tfstate
![Architecture Diagram](./ProofOfWork_ScreenShots/07.png)
## 8. dynamodb table for lockstate handling
![Architecture Diagram](./ProofOfWork_ScreenShots/08.png)
## 9. jumphost instance and worker node
![Architecture Diagram](./ProofOfWork_ScreenShots/09.png)
## 10. jenkins loadbalancer
![Architecture Diagram](./ProofOfWork_ScreenShots/10.png)
## 11. jenkins start page
![Architecture Diagram](./ProofOfWork_ScreenShots/11.png)
## 12. kuberenets status
![Architecture Diagram](./ProofOfWork_ScreenShots/12.png)
## 13. configure of jenkins
![Architecture Diagram](./ProofOfWork_ScreenShots/13.png)
![Architecture Diagram](./ProofOfWork_ScreenShots/15.png)
![Architecture Diagram](./ProofOfWork_ScreenShots/16.png)
![Architecture Diagram](./ProofOfWork_ScreenShots/17.png)
## 14. jenkins deployed the app succesful
![Architecture Diagram](./ProofOfWork_ScreenShots/22.png)
![Architecture Diagram](./ProofOfWork_ScreenShots/18.png)
## 15. App load balancer
![Architecture Diagram](./ProofOfWork_ScreenShots/19.png)
## 16. the app working well
![Architecture Diagram](./ProofOfWork_ScreenShots/20.png)

---


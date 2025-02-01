# 🌍 Greetify: Multilingual Greetings Management Application

> 🚀 A Full-Stack Application demonstrating modern cloud and DevOps principles.

## 📝 Project Overview

Greetify is an end-to-end web application designed to view and manage greetings across various languages, serving as a practical showcase of my growing expertise in DevOps/DevSecOps and Cloud technologies.

## 🚀 Technology Stack

- **Frontend**: Vue.js
- **Backends (Basic microservices)**: Node.js, C# .NET Core
- **Database**: Microsoft SQL Server
- **Containerization**: Docker
- **Infrastructure as Code (IaC)**: Terraform
- **GitOps**: ArgoCD
- **Cloud services**: Azure Kubernetes (AKS), Azure Container Registry, Key Vault, Application Gateway, Log Analytics Workspace, Azure SQL Server, IAM roles
- **Orchestration**: Kubernetes (Azure Kubernetes Service and K3s)
- **Monitoring & Visualization**: Prometheus & Grafana
- **Service Mesh**: Istio

## 🔍 Key Highlights

### 🔹 Kubernetes

- **Helm for Dynamic Manifests**: Built reusable Helm charts for deploying Kubernetes workloads, enabling easy configuration across environments.
- **StatefulSets for SQL Server**: Ensured data persistence and stable network identities for SQL Server instances in Kubernetes.
- **Network Security**: Enforced Kubernetes Network Policies to control ingress/egress traffic.
- **RBAC & Service Accounts**: Restricted pod permissions with Role-Based Access Control (RBAC) and dedicated service accounts.
- **Health Probes**: Configured readiness/liveness probes for reliable app availability.

### 🔹 Azure Infrastructure as Code (IaC) with Terraform

- Provisioned a private AKS cluster, Azure Container Registry (ACR), and SQL Server, securing them with private endpoints and VNet peering to ensure isolated communication.
- Managed Azure RBAC roles and leveraged Managed Identities for secretless authentication.
- Deployed a self-hosted GitHub Actions runner on a private VM, secured via Azure Bastion for SSH access, avoiding public exposure.
- Configured Azure Application Gateway as an ingress controller for secure traffic routing to AKS.
- Used Private DNS Zones to enable seamless name resolution across services in different Virtual Networks.

![Greetify Architecture](https://github.com/Terraformix/greetify/blob/main/azure-architecture-diagram.jpg)


### 🔹 Lightweight cluster setup on Ubuntu using K3s

- **GitHub Actions CI/CD** – Set up a K3s cluster on an Ubuntu VM to host my application.
- **Implemented MetalLB** – Configured MetalLB as a load balancer to manage external traffic for services running in the K3s cluster.


### 🔹 GitOps & CI/CD Automation

- **GitHub Actions CI/CD**: Built pipelines for deploying apps to an AKS Cluster, using both cloud-hosted and self-hosted runners for optimized performance.
- **ArgoCD for GitOps**: Implemented ArgoCD for GitOps, ensuring all deployments are version-controlled and automatically applied to the cluster to avoid manual operations changing the state of the cluster.

![ArgoCD Application](https://github.com/Terraformix/greetify/blob/main/argocd.jpg)


### 🔹 Service Mesh

- **Istio Service Mesh**: Secured pod-to-pod communication with mutual TLS (mTLS), implemented traffic splitting between two versions of my app, and used Istio VirtualServices to simulate canary deployments.

![Service Mesh GET](https://github.com/Terraformix/greetify/blob/main/service-mesh-get.png)
![Service Mesh CREATE](https://github.com/Terraformix/greetify/blob/main/service-mesh-createpng.png)
![Traffic splitting (80/20)](https://github.com/Terraformix/greetify/blob/main/trafficsplit-80-20.png)
![Traffic splitting (50/50)](https://github.com/Terraformix/greetify/blob/main/trafficsplit-50-50.png)
![Traffic splitting (20/80)](https://github.com/Terraformix/greetify/blob/main/trafficsplit-20-80.png)
![Traffic splitting (100/0)](https://github.com/Terraformix/greetify/blob/main/trafficsplit-100-0.png)


### 🔹 DevSecOps

- Secured Kubernetes workloads using Istio Service Mesh, enforcing mutual TLS (mTLS) for encrypted pod-to-pod communication.
- Automated vulnerability scanning with Trivy to detect security issues in base Docker images.
- Enforced Kubernetes security best practices by scanning static manifest files with Kube-sec, identifying misconfigurations before deployment.
- Hardened cluster components using Kube-bench to assess compliance with Kubernetes Security Benchmarks, mitigating potential risks.

### 🔹 Monitoring, Alerting and Observability

- Deployed a Prometheus operator using Helm and made use of Custom Resources to set up monitoring, alerting and visualization within the cluster.
- Created custom prometheus metrics and exposed an API endpoint for Prometheus to pull application metrics from in real-time.
- Created Prometheus Rules (Recording rules and Alert rules) to store basic pre-computed queries and send real-time notifications on metrics to Slack.

![Grafana Dashboard panel 1](https://github.com/Terraformix/greetify/blob/main/grafana-1.png)
![Grafana Dashboard panel 2](https://github.com/Terraformix/greetify/blob/main/grafana-2.png)
![Grafana Dashboard panel 3](https://github.com/Terraformix/greetify/blob/main/grafana-3.png)

![Slack alert 1](https://github.com/Terraformix/greetify/blob/main/alert-1.jpg)
![Slack alert 2](https://github.com/Terraformix/greetify/blob/main/alert-2.jpg)
![Slack alert 3](https://github.com/Terraformix/greetify/blob/main/alert-3.jpg)

### 🔹 Docker compose

- Configured a Docker Compose file to define and manage all required services, ensuring consistent and repeatable deployments.


### 🔹 Scripting & Automation

- Developed Bash scripts to automate Helm chart installations, run scans on Docker images and Static configuration files, and test Istio Virtual Service traffic splitting capabilities.

## 🔐 Why This Project Matters

This project was an opportunity to apply enterprise-level DevOps practices. I gained hands-on experience with:

- Cloud-native tools like Azure, Kubernetes, and Helm
- Secure infrastructure design with RBAC, Network Policies, and OPA enforcement
- Building reliable pipelines and deploying production-ready workloads

Check it out here: [GitHub Link]

#DevOps #Azure #Kubernetes #GitOps #CloudComputing #CI/CD #DevSecOps

# 🌍 Greetify

> 🚀 A Full-Stack Application demonstrating modern Cloud and DevOps principles.

## 📝 Project Overview

Greetify is an end-to-end web application designed to view and manage greetings across various languages, serving as a practical showcase of my growing expertise in DevOps/DevSecOps and Cloud technologies.

## 🚀 Technology Stack

- **Frontend**: Vue.js, HTML, CSS
- **Backends (Basic microservices)**: Node.js, C# .NET Core
- **Database**: Microsoft SQL Server
- **Containerization**: Docker
- **Infrastructure as Code (IaC)**: Terraform
- **CICD & GitOps**: Github Actions & ArgoCD
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

![Azure Architecture Diagram showing the complete infrastructure setup including AKS, ACR, Private Endpoints, and networking components](https://github.com/Terraformix/greetify/blob/main/azure-architecture-diagram.jpg)
*Figure 1: High-level architecture diagram showcasing the Azure infrastructure components and their interactions*


### 🔹 Lightweight cluster setup on Ubuntu using K3s

- **GitHub Actions CI/CD** – Set up a K3s cluster on an Ubuntu VM to host my application.
- **Implemented MetalLB** – Configured MetalLB as a load balancer to manage external traffic for services running in the K3s cluster.


### 🔹 GitOps & CI/CD Automation

- **GitHub Actions CI/CD**: Built pipelines for deploying apps to an AKS Cluster, using both cloud-hosted and self-hosted runners for optimized performance.
- **ArgoCD for GitOps**: Implemented ArgoCD for GitOps, ensuring all deployments are version-controlled and automatically applied to the cluster to avoid manual operations changing the state of the cluster.

![ArgoCD dashboard showing the Greetify application deployment status and health](https://github.com/Terraformix/greetify/blob/main/argocd.jpg)
*Figure 2: ArgoCD UI displaying the synchronized state of Greetify application components*

### 🔹 Service Mesh

- **Istio Service Mesh**: Secured pod-to-pod communication with mutual TLS (mTLS), implemented traffic splitting between two versions of my app, and used Istio VirtualServices to simulate canary deployments.

![Kiali visualization showing GET request flow through the service mesh](https://github.com/Terraformix/greetify/blob/main/service-mesh-get.png)

*Figure 3: Service mesh traffic visualization for GET requests in Kiali*

![Kiali visualization showing CREATE request flow through the service mesh](https://github.com/Terraformix/greetify/blob/main/service-mesh-createpng.png)

*Figure 4: Service mesh traffic visualization for POST requests in Kiali*

![Traffic distribution showing 80/20 split between service versions](https://github.com/Terraformix/greetify/blob/main/trafficsplit-80-20.png)

*Figure 5: Canary deployment with 80/20 traffic split between service versions*

![Traffic distribution showing 50/50 split between service versions](https://github.com/Terraformix/greetify/blob/main/trafficsplit-50-50.png)

*Figure 6: Equal traffic distribution (50/50) between service versions*

![Traffic distribution showing 20/80 split between service versions](https://github.com/Terraformix/greetify/blob/main/trafficsplit-20-80.png)

*Figure 7: Canary deployment with 20/80 traffic split between service versions*

![Traffic distribution showing 100/0 split between service versions](https://github.com/Terraformix/greetify/blob/main/trafficsplit-100-0.png)

*Figure 8: Final migration with 100% traffic to new version*


### 🔹 DevSecOps

- Secured Kubernetes workloads using Istio Service Mesh, enforcing mutual TLS (mTLS) for encrypted pod-to-pod communication.
- Automated vulnerability scanning with Trivy to detect security issues in base Docker images.
- Enforced Kubernetes security best practices by scanning static manifest files with Kube-sec, identifying misconfigurations before deployment.
- Hardened cluster components using Kube-bench to assess compliance with Kubernetes Security Benchmarks, mitigating potential risks.

### 🔹 Monitoring, Alerting and Observability

- Deployed a Prometheus operator using Helm and made use of Custom Resources to set up monitoring, alerting and visualization within the cluster.
- Created custom prometheus metrics and exposed an API endpoint for Prometheus to pull application metrics from in real-time.
- Created Prometheus Rules (Recording rules and Alert rules) to store basic pre-computed queries and send real-time notifications on metrics to Slack.

![Grafana dashboard showing key application metrics and performance indicators](https://github.com/Terraformix/greetify/blob/main/grafana-1.png)

*Figure 9: Grafana dashboard overview of application performance metrics*

![Grafana dashboard displaying detailed system resource utilization](https://github.com/Terraformix/greetify/blob/main/grafana-2.png)

*Figure 10: System resource monitoring dashboard in Grafana*

![Grafana dashboard showing application-specific metrics](https://github.com/Terraformix/greetify/blob/main/grafana-3.png)

*Figure 11: Application-specific metrics*

![Slack notification for critical alert](https://github.com/Terraformix/greetify/blob/main/alert-1.jpg)

*Figure 12: Critical alert notification in Slack*

![Slack notification for warning alert](https://github.com/Terraformix/greetify/blob/main/alert-2.jpg)

*Figure 13: Warning alert notification in Slack*

![Slack notification for resolved alert](https://github.com/Terraformix/greetify/blob/main/alert-3.jpg)

*Figure 14: Alert resolution notification in Slack*



### 🔹 Docker compose

- Configured a Docker Compose file to define and manage all required services, ensuring consistent and repeatable deployments.


### 🔹 Scripting & Automation

- Developed Bash scripts to automate Helm chart installations, run scans on Docker images and Static configuration files, and test Istio Virtual Service traffic splitting capabilities.



## 🔐 Why This Project Matters

This project was an opportunity to apply enterprise-level DevOps practices. I gained hands-on experience with:

- Cloud-native tools like Azure, Kubernetes, and Helm
- Secure infrastructure design with RBAC, Network Policies, and OPA enforcement
- Building reliable pipelines and deploying production-ready workloads

## 📚 Related Repositories

- [Greetify Manifests](https://github.com/YourUsername/greetify-manifests) - Repository to hold various Kubernetes manifests.
- [Greetify Validator](https://github.com/YourUsername/greetify-validator) - C# .NET Core Microservice that validates greetings entered against a static list.

#DevOps #Azure #Kubernetes #GitOps #CloudComputing #CI/CD #DevSecOps #Terraform

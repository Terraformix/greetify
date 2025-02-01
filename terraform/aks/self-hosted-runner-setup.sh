#!/bin/bash

UBUNTU_VERSION=$(lsb_release -r | awk '{print $2}')
GITHUB_REPO_GREETIFY="Terraformix/greetify"
GITHUB_REPO_GREETIFY_VALIDATOR="Terraformix/greetify-validator"

GITHUB_TOKEN_GREETIFY="xxx"
GITHUB_TOKEN_GREETIFY_VALIDATOR="xxx"

RUNNER_VERSION="2.321.0"

sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce

# Configure Docker user and permissions
sudo usermod -aG docker localadmin
sudo systemctl enable docker
sudo systemctl start docker

# Secure Docker socket permissions (more restrictive)
sudo chmod 660 /var/run/docker.sock
sudo chown root:docker /var/run/docker.sock

# Install kubectl
KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
curl -LO "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
sudo apt-get update -y && sudo apt-get install -y terraform

# Install and configure GitHub Actions Runners for Microservice repositories
install_runner() {
    local repo_name=$1
    local repo_url="https://github.com/${repo_name}"
    local token=$2
    local runner_dir="actions-runner-${repo_name//\//-}"

    echo "Setting up runner for ${repo_url}..."
    echo "Token is ${token}..."
    mkdir -p "${runner_dir}" && cd "${runner_dir}"

    curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
    tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

    ./config.sh --unattended --url ${repo_url} --token ${token}

    # Start the runner service
    sudo ./svc.sh install
    sudo ./svc.sh start

    cd ..
}

install_runner "${GITHUB_REPO_GREETIFY}" "${GITHUB_TOKEN_GREETIFY}"
install_runner "${GITHUB_REPO_GREETIFY_VALIDATOR}" "${GITHUB_TOKEN_GREETIFY_VALIDATOR}"

az login --identity

alias k=kubectl

# Apply group changes without requiring a logout
newgrp docker
exit 0
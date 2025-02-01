#!/bin/bash


for arg in "$@"
do
  if [[ "$arg" == "nginx" ]]; then
    INSTALL_NGINX=true
  elif [[ "$arg" == "prometheus" ]]; then
    INSTALL_PROMETHEUS=true
  elif [[ "$arg" == "certmanager" ]]; then
    INSTALL_CERTMANAGER=true
  elif [[ "$arg" == "argocd" ]]; then
    INSTALL_ARGOCD=true
  elif [[ "$arg" == "istio" ]]; then
    INSTALL_ISTIO=true
  else
    echo "Unknown argument: $arg"
    exit 1
  fi
done

if [[ "$INSTALL_NGINX" = true ]]; then
  echo "Installing nginx..."
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo update
  helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --namespace greetify --create-namespace
else
  echo "Skipping NGINX install.."
fi

if [[ "$INSTALL_PROMETHEUS" = true ]]; then
  echo "Installing prometheus..."
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo update
  # For Docker Desktop
  #helm upgrade --install prometheus prometheus-community/kube-prometheus-stack --namespace greetify --create-namespace --set prometheus-node-exporter.hostRootFsMount.enabled=false -f ../prometheus/values.yaml
  helm upgrade --install prometheus prometheus-community/kube-prometheus-stack --namespace greetify --create-namespace -f ../prometheus/values.yaml

else
  echo "Skipping prometheus install.."
fi

if [[ "$INSTALL_CERTMANAGER" = true ]]; then
  echo "Installing certmanager..."
  helm repo add jetstack https://charts.jetstack.io
  helm repo update
  helm upgrade --install cert-manager jetstack/cert-manager --namespace greetify --create-namespace --version v1.16.2 --set crds.enabled=true
else
  echo "Skipping certmanager install.."
fi

if [[ "$INSTALL_ARGOCD" = true ]]; then
  echo "Installing argocd..."
  helm repo add argo https://argoproj.github.io/argo-helm
  helm repo update
  helm upgrade --install argocd argo/argo-cd --namespace argocd --create-namespace
else
  echo "Skipping argocd install.."
fi

if [[ "$INSTALL_ISTIO" = true ]]; then
  echo "Installing istio..."
  curl -L https://istio.io/downloadIstio | sh -
  cd istio-1.24.2
  export PATH=$PWD/bin:$PATH
  istioctl install --set profile=demo -y
  kubectl label namespace greetify istio-injection=enabled
  kubectl apply -f samples/addons/kiali.yaml
  kubectl apply -f samples/addons/prometheus.yaml
else
  echo "Skipping istio install.."
fi
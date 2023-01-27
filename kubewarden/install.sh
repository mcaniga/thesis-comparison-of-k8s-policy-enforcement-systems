#!/bin/bash

source k8s-helpers.sh

# Install Kubewarden - crds 1.2.3, controller 1.4.0, defaults 1.5.1
# Available chart versions: https://github.com/kubewarden/helm-charts/releases

function install_kubewarden {
  echo "Installing kubewarden (crds - 1.2.3, controller 1.4.0, defaults 1.5.1)..."
  # Install cert manager - prerequisite of kubewarden
  # TODO: specify exact version instead of latest
  kubectl apply -f https://github.com/jetstack/cert-manager/releases/latest/download/cert-manager.yaml
  kubectl wait --for=condition=Available deployment --timeout=2m -n cert-manager --all
  # Install kubewarden
  helm repo add kubewarden https://charts.kubewarden.io
  helm install --wait -n kubewarden --create-namespace kubewarden-crds kubewarden/kubewarden-crds --version 1.2.3
  helm install --wait -n kubewarden kubewarden-controller kubewarden/kubewarden-controller --version 1.4.0
  helm install --wait -n kubewarden kubewarden-defaults kubewarden/kubewarden-defaults --version 1.5.1
}

if namespace_exists "kubewarden"; then
  echo "Kubewarden already installed";
else
  install_kubewarden
fi
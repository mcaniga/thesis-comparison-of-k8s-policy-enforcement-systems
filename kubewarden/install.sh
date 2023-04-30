#!/bin/bash

source k8s-helpers.sh

# Install Kubewarden - crds 1.3.0, controller 1.5.0, defaults 1.6.0
# Available chart versions: https://github.com/kubewarden/helm-charts/releases

function install_kubewarden {
  echo "Installing kubewarden (cert-manager - 1.11.1, crds - 1.3.0, controller 1.5.0, defaults 1.6.0)..."
  # Install cert manager - prerequisite of kubewarden
  kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.11.1/cert-manager.yaml >> $SC_PROJECT_ROOT/exec.log
  echo "Waiting for cert manager..."
  kubectl wait --for=condition=Available deployment --timeout=2m -n cert-manager --all >> $SC_PROJECT_ROOT/exec.log
  # Install kubewarden
  helm repo add kubewarden https://charts.kubewarden.io >> $SC_PROJECT_ROOT/exec.log
  echo "Waiting for crds..."
  helm install --wait -n kubewarden --create-namespace kubewarden-crds kubewarden/kubewarden-crds --version 1.3.0 >> $SC_PROJECT_ROOT/exec.log
  echo "Waiting for controller..."
  helm install --wait -n kubewarden kubewarden-controller kubewarden/kubewarden-controller --version 1.5.0 >> $SC_PROJECT_ROOT/exec.log
  echo "Waiting for defaults..."
  helm install --wait -n kubewarden kubewarden-defaults kubewarden/kubewarden-defaults --version 1.6.0 >> $SC_PROJECT_ROOT/exec.log
}

if namespace_exists "kubewarden"; then
  echo "Kubewarden already installed";
else
  install_kubewarden
fi
#!/bin/bash

source k8s-helpers.sh

# Install Kubewarden - crds 1.2.3, controller 1.4.0, defaults 1.5.1
# Available chart versions: https://github.com/kubewarden/helm-charts/releases

function install_kubewarden {
  echo "Installing kubewarden (crds - 1.2.3, controller 1.4.0, defaults 1.5.1)..."
  # Install cert manager - prerequisite of kubewarden
  kubectl apply -f https://github.com/jetstack/cert-manager/releases/latest/download/cert-manager.yaml >> $SC_PROJECT_ROOT/exec.log
  echo "Waiting for cert manager..."
  kubectl wait --for=condition=Available deployment --timeout=2m -n cert-manager --all >> $SC_PROJECT_ROOT/exec.log
  # Install kubewarden
  helm repo add kubewarden https://charts.kubewarden.io >> $SC_PROJECT_ROOT/exec.log
  echo "Waiting for crds..."
  helm install --wait -n kubewarden --create-namespace kubewarden-crds kubewarden/kubewarden-crds --version 1.2.3 >> $SC_PROJECT_ROOT/exec.log
  echo "Waiting for controller..."
  helm install --wait -n kubewarden kubewarden-controller kubewarden/kubewarden-controller --version 1.4.0 >> $SC_PROJECT_ROOT/exec.log
  echo "Waiting for defaults..."
  helm install --wait -n kubewarden kubewarden-defaults kubewarden/kubewarden-defaults --version 1.5.1 >> $SC_PROJECT_ROOT/exec.log
}

if namespace_exists "kubewarden"; then
  echo "Kubewarden already installed";
else
  install_kubewarden
fi
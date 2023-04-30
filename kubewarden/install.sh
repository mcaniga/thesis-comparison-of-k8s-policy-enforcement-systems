#!/bin/bash

source k8s-helpers.sh

# Install Kubewarden
# Available chart versions: https://github.com/kubewarden/helm-charts/releases

function install_kubewarden {
  cert_manager_version=$(yq eval '.kubewarden.certManager' $SETTINGS_PATH)
  crds_version=$(yq eval '.kubewarden.crds' $SETTINGS_PATH)
  controller_version=$(yq eval '.kubewarden.controller' $SETTINGS_PATH)
  defaults_version=$(yq eval '.kubewarden.defaults' $SETTINGS_PATH)
  
  echo "Installing kubewarden (cert-manager - $cert_manager_version, crds - $crds_version, controller - $controller_version, defaults - $defaults_version)..."
  # Install cert manager - prerequisite of kubewarden
  kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/$cert_manager_version/cert-manager.yaml >> $SC_PROJECT_ROOT/exec.log
  echo "Waiting for cert manager..."
  kubectl wait --for=condition=Available deployment --timeout=2m -n cert-manager --all >> $SC_PROJECT_ROOT/exec.log
  # Install kubewarden
  helm repo add kubewarden https://charts.kubewarden.io >> $SC_PROJECT_ROOT/exec.log
  echo "Waiting for crds..."
  helm install --wait -n kubewarden --create-namespace kubewarden-crds kubewarden/kubewarden-crds --version $crds_version >> $SC_PROJECT_ROOT/exec.log
  echo "Waiting for controller..."
  helm install --wait -n kubewarden kubewarden-controller kubewarden/kubewarden-controller --version $controller_version >> $SC_PROJECT_ROOT/exec.log
  echo "Waiting for defaults..."
  helm install --wait -n kubewarden kubewarden-defaults kubewarden/kubewarden-defaults --version $defaults_version >> $SC_PROJECT_ROOT/exec.log
}

if namespace_exists "kubewarden"; then
  echo "Kubewarden already installed";
else
  install_kubewarden
fi
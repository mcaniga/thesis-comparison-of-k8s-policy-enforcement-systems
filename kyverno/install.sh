#!/bin/bash

source k8s-helpers.sh

# Install Kyverno in 'Standalone' mode - only one replica, requests will be rejected when Kyverno is unavailable
# For production installation, use 'helm' package manager for Kubernetes, specify exact version, and set at least 3 replicas.

function install_kyverno {
  kyverno_version=$(yq eval '.kyvernoVersion' $SETTINGS_PATH)
  echo "Installing Kyverno $kyverno_version in Standalone mode"
  echo "For production installation, use 'helm' package manager for Kubernetes, specify exact version, and set at least 3 replicas."
  kubectl create -f https://raw.githubusercontent.com/kyverno/kyverno/$kyverno_version/config/release/install.yaml >> $SC_PROJECT_ROOT/exec.log
  echo "Installing Kyverno $kyverno_version ..."
  wait_until_pods_ready "kyverno"
}

if namespace_exists "kyverno"; then
  echo "Kyverno already installed";
else
  install_kyverno
fi
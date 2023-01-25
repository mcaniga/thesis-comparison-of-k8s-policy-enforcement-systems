#!/bin/bash

source k8s-helpers.sh

# Install Kyverno 1.7 in 'Standalone' mode - only one replica, requests will be rejected when Kyverno is unavailable
# For production installation, use 'helm' package manager for Kubernetes, specify exact version, and set at least 3 replicas.
# TODO: use helm?

function install_kyverno {
  echo "Installing Kyverno 1.7 in Standalone mode"
  echo "For production installation, use 'helm' package manager for Kubernetes, specify exact version, and set at least 3 replicas."
  kubectl create -f https://raw.githubusercontent.com/kyverno/kyverno/release-1.7/config/release/install.yaml
  echo "Installing Kyverno..."
  wait_until_pods_ready "kyverno"
}

if namespace_exists "kyverno"; then
  echo "Kyverno already installed";
else
  install_kyverno
fi
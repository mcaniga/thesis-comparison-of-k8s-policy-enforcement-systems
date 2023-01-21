#!/bin/bash

source k8s-helpers.sh

# Install 'latest' Kyverno in 'Standalone' mode - only one replica, requests will be rejected when Kyverno is unavailable
# For production installation, use 'helm' package manager for Kubernetes, specify exact version, and set at least 3 replicas.
# TODO: use helm?
# TODO: version can be specified also without helm, can't 'latest' in final form of thesis - https://kyverno.io/docs/installation/#install-kyverno-using-yamls

function install_kyverno {
  echo "Installing latest Kyverno in Standalone mode"
  echo "For production installation, use 'helm' package manager for Kubernetes, specify exact version, and set at least 3 replicas."
  kubectl create -f https://raw.githubusercontent.com/kyverno/kyverno/main/config/install.yaml
}

if namespace_exists "kyverno"; then
  echo "Kyverno already installed";
else
  install_kyverno
fi
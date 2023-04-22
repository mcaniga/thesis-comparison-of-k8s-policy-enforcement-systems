#!/bin/bash

source k8s-helpers.sh

# Install OPA Gatekeeper 3.11

function install_gatekeeper {
  kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/release-3.11/deploy/gatekeeper.yaml >> $SC_PROJECT_ROOT/exec.log
  echo "Installing gatekeeper..."
  wait_until_pods_ready "gatekeeper-system"
}

if namespace_exists "gatekeeper-system"; then
  echo "Gatekeeper already installed";
else
  install_gatekeeper
fi
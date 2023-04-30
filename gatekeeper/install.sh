#!/bin/bash

source k8s-helpers.sh

# Install OPA Gatekeeper

function install_gatekeeper {
  gatekeeper_version=$(yq eval '.gatekeeperVersion' $SETTINGS_PATH)
  kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/$gatekeeper_version/deploy/gatekeeper.yaml >> $SC_PROJECT_ROOT/exec.log
  echo "Installing OPA Gatekeeper - $gatekeeper_version ..."
  wait_until_pods_ready "gatekeeper-system"
}

if namespace_exists "gatekeeper-system"; then
  echo "Gatekeeper already installed";
else
  install_gatekeeper
fi
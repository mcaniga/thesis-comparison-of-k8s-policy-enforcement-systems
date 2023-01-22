#!/bin/bash

source k8s-helpers.sh

# Install OPA Gatekeeper 3.11
# TODO: use helm?

function install_gatekeeper {
  kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/release-3.11/deploy/gatekeeper.yaml
  wait_until_pod_ready "gatekeeper.sh/operation=audit" "gatekeeper-system"
}

if namespace_exists "gatekeeper-system"; then
  echo "Gatekeeper already installed";
else
  install_gatekeeper
fi
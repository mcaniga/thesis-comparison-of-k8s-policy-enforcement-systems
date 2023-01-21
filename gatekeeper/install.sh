#!/bin/bash

source k8s-helpers.sh

# TODO: use helm?
# TODO: version can be specified also without helm, can't use 'master' in final form of thesis

function install_gatekeeper {
  kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
}

if namespace_exists "gatekeeper-system"; then
  echo "Gatekeeper already installed";
else
  install_gatekeeper
fi
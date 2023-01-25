#!/bin/bash

source k8s-helpers.sh

# Waits until all kyverno clusterpolicies in namespace are in ready state.
# Accepts positional arguments:
#   $1 - namespace
# Uses global variable:
#   $PROJECT_ROOT - path to the project root
function wait_until_clusterpolicies_are_ready {
  kubectl wait --for=condition=ready clusterpolicy -n $1 --all >>  $PROJECT_ROOT/exec.log
}

wait_until_clusterpolicies_are_ready "kyverno"
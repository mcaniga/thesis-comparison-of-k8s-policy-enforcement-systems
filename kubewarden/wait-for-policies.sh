#!/bin/bash

# Waits until all kubewarden clusteradmissionpolicies in namespace are in ready state.
# Accepts positional arguments:
#   $1 - namespace
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function wait_until_clusteradmissionpolicies_are_ready {
  sleep 10
  # cluster admission policy takes long time to be ready, wait up to 2 minutes
  kubectl wait --for=condition=PolicyActive clusteradmissionpolicy.policies.kubewarden.io -n $1 --all --timeout=120s >>  $SC_PROJECT_ROOT/exec.log
}

wait_until_clusteradmissionpolicies_are_ready "kubewarden"
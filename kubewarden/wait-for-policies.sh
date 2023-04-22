#!/bin/bash

# Waits until all kubewarden clusteradmissionpolicies in namespace are in ready state.
# Accepts positional arguments:
#   $1 - namespace
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
#   $SETTINGS_PATH - path from project root to parameters yaml
function wait_until_clusteradmissionpolicies_are_ready {
  # Exit with failure if SETTINGS_PATH is not provided
  if [ -z $SETTINGS_PATH ]; then
          echo 'Settings path (-s) is required for kubewarden policies' >&2
          exit 1
  fi
  sleep 10
  # cluster admission policy takes long time to be ready, wait up to 2 minutes
  kubectl wait --for=condition=PolicyActive clusteradmissionpolicy.policies.kubewarden.io -n $1 --all --timeout=120s >>  $SC_PROJECT_ROOT/exec.log
}

wait_until_clusteradmissionpolicies_are_ready "kubewarden"
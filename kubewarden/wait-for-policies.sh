#!/bin/bash

# Waits until all kubewarden clusteradmissionpolicies in namespace are in ready state.
# Accepts positional arguments:
#   $1 - namespace
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function wait_until_clusteradmissionpolicies_are_ready {
  kubectl wait --for=condition=PolicyActive clusteradmissionpolicy.policies.kubewarden.io -n $1 --all >>  $SC_PROJECT_ROOT/exec.log
}

wait_until_clusteradmissionpolicies_are_ready "kubewarden"
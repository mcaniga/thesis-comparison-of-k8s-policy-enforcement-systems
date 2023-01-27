#!/bin/bash

# Applies gatekeeper constraints.
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function apply_constraints {
    # Wait for constraint templates to be applied
    sleep 2
    for constraint in "$SC_PROJECT_ROOT"/gatekeeper/constraints/*; do
      # TODO: maybe namespace should be added
      kubectl apply -f $constraint >> $SC_PROJECT_ROOT/exec.log
    done
    # Wait for constraints to be applied
    sleep 2
}

apply_constraints
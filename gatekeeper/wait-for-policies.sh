#!/bin/bash

# Applies gatekeeper constraints.
# Uses global variable:
#   $PROJECT_ROOT - path to the project root
function apply_constraints {
    # Wait for constraint templates to be applied
    sleep 2
    for constraint in "$PROJECT_ROOT"/gatekeeper/constraints/*; do
      # TODO: maybe namespace should be added
      kubectl apply -f $constraint >> $PROJECT_ROOT/exec.log
    done
    # Wait for constraints to be applied
    sleep 2
}

apply_constraints
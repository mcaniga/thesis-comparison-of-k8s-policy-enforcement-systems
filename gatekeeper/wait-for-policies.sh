#!/bin/bash

# Applies gatekeeper constraints without parameters.
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function apply_non_parametric_constraints {
    echo "Applying non parametric constraints"
    # Wait for constraint templates to be applied
    sleep 2
    for constraint_path in "$SC_PROJECT_ROOT"/gatekeeper/constraints/*; do
      kubectl apply -f $constraint_path >> $SC_PROJECT_ROOT/exec.log
    done
    # Wait for constraints to be applied
    sleep 2
    echo "Non parametric constraints applied"
}

# Applies gatekeeper constraints with parameters.
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
#   $NAMESPACE - namespace
#   $SETTINGS_PATH - path from project root to parameters yaml
function apply_parametric_constraints {
    echo "Applying parametric constraints"
    for constraint_path in "$SC_PROJECT_ROOT"/gatekeeper/constraints-charts/*; do
      constraint_name=$(basename $constraint_path)
      policy_settings="$constraint_path/$constraint_name.yml"
      # make specific values.yml override from input params for given constraint
      echo "henlo"
      cat $policy_settings
      yq eval ".["$constraint_name"]" $SETTINGS_PATH > $policy_settings
      # install helm release for parametric policy with specified parameters
      helm install $constraint_name . -f $policy_settings -n $NAMESPACE
    done
    # Wait for constraints to be applied
    sleep 5
    echo "Parametric constraints applied"
}

# Applies gatekeeper constraints.
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
#   $NAMESPACE - namespace
#   $SETTINGS_PATH - path from project root to parameters yaml
function apply_constraints {
    # Exit with failure if SETTINGS_PATH is not provided
    if [ -z $SETTINGS_PATH ]; then
            echo 'Settings path (-s) is required for gatekeeper policies' >&2
            exit 1
    fi
    apply_non_parametric_constraints
    apply_parametric_constraints
}

apply_constraints
#!/bin/bash

source k8s-helpers.sh

# Checks if cluster policies are ready
# Returns "false" if cluster policies are not ready
function are_clusterpolicies_ready {
  # extracts 4th (READY) column, removes header line, check if at least one cluster policy has ready = "false"
  kubectl get clusterpolicy -A | awk '{print $4}' | tail -n +2 | while read line; do [[ "$line" == "false" ]] && echo "false"; done
}

# Check every second if Kyverno clusterpolicies are ready
while [ $(are_clusterpolicies_ready) = "false" ]; do
        sleep 1
done
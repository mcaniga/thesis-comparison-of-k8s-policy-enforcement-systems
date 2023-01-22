#!/bin/bash

source k8s-helpers.sh

# Checks if cluster policies are ready
# Extracts 4th (READY) column, removes header line, check if at least one cluster policy has ready = "false"
# Exits with 0 if cluster policies are ready, otherwise with 1
function are_clusterpolicies_ready {
  # extracts 4th (READY) column, removes header line, check if at least one cluster policy has ready = "false"
  READINESS_FLAGS=$(kubectl get clusterpolicy -A | awk '{print $4}' | tail -n +2)
  while read -r line
  do
    if [ $line == "false" ]; then
      return 1;
    fi
  done < <($READINESS_FLAGS)
  return 0;
}

# Check every second if Kyverno clusterpolicies are ready
are_clusterpolicies_ready
while [ $? -eq 1 ]; do
        sleep 1
        are_clusterpolicies_ready
done
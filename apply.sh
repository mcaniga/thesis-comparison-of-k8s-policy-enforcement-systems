#!/bin/bash

# Exit if simple command exits (NOT part of 'if', '&&', '||', ...) with a nonzero exit value
set -e

# Import k8s helper functions
source ./k8s-helpers.sh

echo "-------------------------------"
echo "Starting cluster security check"
echo "-------------------------------"

SUCCESSFULLY_ACCEPTED=()
SUCCESSFULLY_REJECTED=()
WRONGLY_ACCEPTED=()
WRONGLY_REJECTED=()

# Parse -n <namespace> argument
DELETE_NAMESPACE='false'
while getopts n:d flag
do
    case "${flag}" in
        n) NAMESPACE=${OPTARG};;
        d) DELETE_NAMESPACE='true';;
    esac
done

if [ -z $NAMESPACE ]; then
        echo 'Namespace (-n) is required' >&2
        exit 1
fi

# Check if namespace exists, if not create new
if namespace_exists $NAMESPACE; then
  echo "Using existing namespace $NAMESPACE";
else
  echo "Creating namespace $NAMESPACE";
  create_namespace $NAMESPACE
fi

# Apply vulnerable pods to cluster
echo ""
echo "Applying vulnerable pods"
cd ./pods/vulnerable/
for filename in *; do
    # Strip .yml from filename
    POD_NAME=$(extract_podname $filename)
    # Try to apply vulnerable pod to cluster
    apply_pod $filename $NAMESPACE
    # Check if vulnerable pod was applied to cluster
    if pod_exists $NAMESPACE $POD_NAME; then
      echo "[WARN] Pod: $POD_NAME was applied to cluster but it should not.";
      # Add pod name to list of wrongly accepted pods
      WRONGLY_ACCEPTED+=($POD_NAME)
      # Delete the vulnerable pod from cluster
      delete_pod $filename $NAMESPACE
    else
      echo "Pod: $POD_NAME was successfully rejected";
      # Add pod name to list of successfully rejected pods
      SUCCESSFULLY_REJECTED+=($POD_NAME)
    fi
done

# Apply secure pods to cluster
echo ""
echo "Applying secure pods"
cd ../secure/
for filename in *; do
    # Strip .yml from filename
    POD_NAME=$(extract_podname $filename)
    # Try to apply secure pod to cluster
    apply_pod $filename $NAMESPACE
    # Check if namespace exists, if not create new
    if pod_exists $NAMESPACE $POD_NAME; then
      echo "Pod: $POD_NAME was successfully applied to cluster.";
      # Add pod name to list of successfully accepted pods
      SUCCESSFULLY_ACCEPTED+=($POD_NAME)
      # Delete the secure pod from cluster
      delete_pod $filename $NAMESPACE
    else
      echo "[WARN] Pod: $POD_NAME was rejected but it should not.";
      # Add pod name to list of wrongly rejected pods
      WRONGLY_REJECTED+=($POD_NAME)
    fi
done

if [ "$DELETE_NAMESPACE" = true ] ; then
    delete_namespace $NAMESPACE
fi
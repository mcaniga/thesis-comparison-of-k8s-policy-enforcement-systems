#!/bin/bash

# Exit if simple command exits (NOT part of 'if', '&&', '||', ...) with a nonzero exit value
set -e

echo "-------------------------------"
echo "Starting cluster security check"
echo "-------------------------------"

SUCCESSFULLY_ACCEPTED=()
SUCCESSFULLY_REJECTED=()
WRONGLY_ACCEPTED=()
WRONGLY_REJECTED=()

# Parse -n <namespace> argument
while getopts n: flag
do
    case "${flag}" in
        n) NAMESPACE=${OPTARG};;
    esac
done

if [ -z $NAMESPACE ]; then
        echo 'Namespace (-n) is required' >&2
        exit 1
fi

# Check if namespace exists, if not create new
if kubectl get namespace | grep -q "^$NAMESPACE "; then
  echo "Using existing namespace $NAMESPACE";
else
  echo "Creating namespace $NAMESPACE";
  kubectl create namespace $NAMESPACE
fi

# Apply vulnerable pods to cluster
echo ""
echo "Applying vulnerable pods"
cd ./pods/vulnerable/
for filename in *; do
    # Strip .yml from filename
    POD_NAME=$(echo $filename | cut -f1 -d".")
    # Try to apply vulnerable pod to cluster
    kubectl apply -f $filename -n $NAMESPACE
    # Check if vulnerable pod was applied to cluster
    if kubectl get pods -n $NAMESPACE | grep -q "^$POD_NAME "; then
      echo "[WARN] Pod: $POD_NAME was applied to cluster but it should not.";
      # Add pod name to list of wrongly accepted pods
      WRONGLY_ACCEPTED+=($POD_NAME)
      # Delete the vulnerable pod from cluster
      kubectl delete --wait=false -f $filename -n $NAMESPACE
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
    POD_NAME=$(echo $filename | cut -f1 -d".")
    # Try to apply secure pod to cluster
    kubectl apply -f $filename -n $NAMESPACE
    # Check if namespace exists, if not create new
    if kubectl get pods -n $NAMESPACE | grep -q "^$POD_NAME "; then
      echo "Pod: $POD_NAME was successfully applied to cluster.";
      # Add pod name to list of successfully accepted pods
      SUCCESSFULLY_ACCEPTED+=($POD_NAME)
      # Delete the secure pod from cluster
      kubectl delete --wait=false -f $filename -n $NAMESPACE
    else
      echo "[WARN] Pod: $POD_NAME was rejected but it should not.";
      # Add pod name to list of wrongly rejected pods
      WRONGLY_REJECTED+=($POD_NAME)
    fi
done
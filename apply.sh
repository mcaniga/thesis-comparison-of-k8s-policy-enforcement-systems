#!/bin/bash

# Exit if simple command exits (NOT part of 'if', '&&', '||', ...) with a nonzero exit value
# For now commented out, because sometimes when kubectl ends with error (eg. Kyverno already exists), we want to continue - improve error handling/input validation
# set -e

# Import k8s helper functions
source ./k8s-helpers.sh

echo "-------------------------------"
echo "Starting cluster security check"
echo "-------------------------------"

date >> exec.log

export SC_PROJECT_ROOT=$(pwd)

SUCCESSFULLY_ACCEPTED=()
SUCCESSFULLY_REJECTED=()
WRONGLY_ACCEPTED=()
WRONGLY_REJECTED=()

# Parse -n <namespace> argument
DELETE_NAMESPACE='false'
while getopts n:e:p:d flag
do
    case "${flag}" in
        n) NAMESPACE=${OPTARG};;
        e) ENFORCEMENT_LIB=${OPTARG};;
        p) SECURITY_PROFILE=${OPTARG};;
        d) DELETE_NAMESPACE='true';;
    esac
done

# Exit with failure if namespace is not provided
if [ -z $NAMESPACE ]; then
        echo 'Namespace (-n) is required' >&2
        exit 1
fi

# Check if namespace exists, if not create new
if namespace_exists $NAMESPACE; then
  echo "Using existing namespace: '$NAMESPACE'";
else
  echo "Creating namespace $NAMESPACE";
  create_namespace $NAMESPACE
fi

# Install enforcement lib if library name is specified
if [ -n "$ENFORCEMENT_LIB" ]; then
  install_enforcement_lib $ENFORCEMENT_LIB $NAMESPACE
fi

# Apply security profile to namespace if profile is specified
if [ -n "$SECURITY_PROFILE" ]; then
  apply_security_profile $SECURITY_PROFILE $NAMESPACE
fi

# Apply vulnerable pods to cluster
echo ""
echo "Applying vulnerable pods..."
cd ./pods/vulnerable/
for filename in *; do
    # Strip .yml from filename
    POD_NAME=$(extract_podname $filename)
    # Try to apply vulnerable pod to cluster
    apply_resource $filename $NAMESPACE
    # Check if vulnerable pod was applied to cluster
    if pod_exists $NAMESPACE $POD_NAME; then
      # Add pod name to list of wrongly accepted pods
      WRONGLY_ACCEPTED+=($POD_NAME)
      # Delete the vulnerable pod from cluster
      delete_resource $filename $NAMESPACE
    else
      # Add pod name to list of successfully rejected pods
      SUCCESSFULLY_REJECTED+=($POD_NAME)
    fi
done

# Apply secure pods to cluster
echo ""
echo "Applying secure pods..."
cd ../secure/
for filename in *; do
    # Strip .yml from filename
    POD_NAME=$(extract_podname $filename)
    # Try to apply secure pod to cluster
    apply_resource $filename $NAMESPACE
    # Check if namespace exists, if not create new
    if pod_exists $NAMESPACE $POD_NAME; then
      # Add pod name to list of successfully accepted pods
      SUCCESSFULLY_ACCEPTED+=($POD_NAME)
      # Delete the secure pod from cluster
      delete_resource $filename $NAMESPACE
    else
      # Add pod name to list of wrongly rejected pods
      WRONGLY_REJECTED+=($POD_NAME)
    fi
done

if [ "$DELETE_NAMESPACE" = true ] ; then
    delete_namespace $NAMESPACE
fi

SUCCESSFULL_TOTAL=$((${#SUCCESSFULLY_ACCEPTED[@]} + ${#SUCCESSFULLY_REJECTED[@]}))
WRONG_TOTAL=$((${#WRONGLY_ACCEPTED[@]} + ${#WRONGLY_REJECTED[@]}))
TOTAL=$(($SUCCESSFULL_TOTAL + $WRONG_TOTAL))

echo "-------------------------------"
echo "Results"
echo "-------------------------------"
echo "Successfull: $SUCCESSFULL_TOTAL/$TOTAL"
echo "Unsuccessfull: $WRONG_TOTAL/$TOTAL"

echo "Successfully accepted:"
for i in "${SUCCESSFULLY_ACCEPTED[@]}"; do echo "$i"; done
echo ""

echo "Successfully rejected:"
for i in "${SUCCESSFULLY_REJECTED[@]}"; do echo "$i"; done
echo ""

echo "Wrongly accepted:"
for i in "${WRONGLY_ACCEPTED[@]}"; do echo "$i"; done
echo ""

echo "Wrongly rejected:"
for i in "${WRONGLY_REJECTED[@]}"; do echo "$i"; done
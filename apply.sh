#!/bin/bash

echo "-------------------------------"
echo "Starting cluster security check"
echo "-------------------------------"
kubectl create namespace cluster-security-check

echo ""
echo "Applying vulnerable pods"
cd ./pods/vulnerable/
for filename in *; do
    # Strip .yml from filename
    POD_NAME=$(echo $filename | cut -f1 -d".")
    FOUND_POD_NAME=$(kubectl get pods -n cluster-security-check | grep POD_NAME)
    echo $POD_NAME
    echo $FOUND_POD_NAME
done

echo ""
echo "Applying secure pods"
cd ../secure/
for filename in *; do
    # Strip .yml from filename
    POD_NAME=$(echo $filename | cut -f1 -d".")
    FOUND_POD_NAME=$(kubectl get pods -n cluster-security-check | grep POD_NAME)
    echo $POD_NAME
    echo $FOUND_POD_NAME
done

kubectl delete namespace cluster-security-check
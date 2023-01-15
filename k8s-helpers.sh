#!/bin/bash

# Schedules k8s pod to be deleted. Does not wait for pod termination to be over.
# Accepts positional arguments:
#   $1 - path to pod declaration file
#   $2 - namespace
function delete_pod {
  kubectl delete --wait=false -f $1 -n $2
}

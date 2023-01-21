#!/bin/bash

# Extracts pod name from name of its declaration '.yml' file.
# Accepts positional arguments:
#   $1 - filename
function extract_podname {
  echo $1 | cut -f1 -d"."
}

# Checks if pod exists in given namespace. Returns non-zero code if pod is not found.
# Accepts positional arguments:
#   $1 - namespace
#   $2 - pod name
function pod_exists {
  kubectl get pods -n $1 | grep -q "^$2 "
}

# Checks if namespace exists. Returns non-zero code if namespace is not found.
# Accepts positional arguments:
#   $1 - namespace
function namespace_exists {
  kubectl get namespace | grep -q "^$1 "
}

# Applies k8s pod to given namespace.
# Accepts positional arguments:
#   $1 - path to pod declaration file
#   $2 - namespace
# Uses global variable:
#   $PROJECT_ROOT - path to the project root
function apply_pod {
  kubectl apply -f $1 -n $2 >> $PROJECT_ROOT/exec.log
}

# Schedules k8s pod to be deleted. Does not wait for pod termination to be over.
# Accepts positional arguments:
#   $1 - path to pod declaration file
#   $2 - namespace
# Uses global variable:
#   $PROJECT_ROOT - path to the project root
function delete_pod {
  kubectl delete --wait=false -f $1 -n $2 >> $PROJECT_ROOT/exec.log
}

# Creates k8s namespace.
# Accepts positional arguments:
#   $1 - namespace
# Uses global variable:
#   $PROJECT_ROOT - path to the project root
function create_namespace {
  kubectl create namespace $1 >> exec.log
}

# Schedules k8s namespace along with its pods to be deleted. Does not wait for pod termination to be over.
# Accepts positional arguments:
#   $1 - namespace
# Uses global variable:
#   $PROJECT_ROOT - path to the project root
function delete_namespace {
  kubectl delete namespace --wait=false $1 >>  $PROJECT_ROOT/exec.log
}

# Installs pod security enforcement library.
# Accepts positional arguments:
#   $1 - name of the lib, valid names: 'gatekeeper' | 'kyverno'
#   $2 - namespace
function install_enforcement_lib {
  if [[ $1 != "kyverno" && $1 != "gatekeeper" ]]; then
    echo 'Unknown enforcement library (-e). Known libraries - "kyverno", "gatekeeper"' >&2
    exit 1
  fi

  bash ./$1/install.sh

  for policy in ./$1/policies/*; do
      kubectl apply -f $policy -n $2
  done
}
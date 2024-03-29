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

# Applies k8s resource to given namespace.
# Accepts positional arguments:
#   $1 - path to resource declaration file
#   $2 - namespace
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function apply_resource {
  kubectl apply -f $1 -n $2 >> $SC_PROJECT_ROOT/exec.log
}

# Schedules k8s pod to be deleted. Does not wait for pod termination to be over.
# Accepts positional arguments:
#   $1 - path to pod declaration file
#   $2 - namespace
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function delete_resource {
  kubectl delete --wait=false -f $1 -n $2 >> $SC_PROJECT_ROOT/exec.log
}

# Creates k8s namespace.
# Accepts positional arguments:
#   $1 - namespace
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function create_namespace {
  kubectl create namespace $1 >> $SC_PROJECT_ROOT/exec.log
}

# Extracts field from pod annotations
# Accepts positional arguments:
#   $1 - pod name
#   $2 - namespace
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function extract_readable_name {
  kubectl get pod $1 -n $2 -o=jsonpath="{.metadata.annotations.readableName}"
}

# Extracts field from pod annotations
# Accepts positional arguments:
#   $1 - pod name
#   $2 - namespace
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function extract_vulnerability_reason {
  kubectl get pod $1 -n $2 -o=jsonpath="{.metadata.annotations.vulnerabilityReason}"
}

# Replaces space with underscores
# Accepts positional arguments:
#   $1 - string
function replace_space_with_underscores {
  local STR="$1"
  echo "${STR// /_}"
}

# Replaces underscores with space
# Accepts positional arguments:
#   $1 - string
function replace_undescores_with_space {
  local STR="$1"
  echo "${STR//_/ }"
}

# Replaces underscores with space
# Accepts positional arguments:
#   $1 - string
function replace_undescores_with_space {
  local STR="$1"
  echo "${STR//_/ }"
}

# Changes label of given namespace.
# If label already exists, it will be overwritten.
# Accepts positional arguments:
#   $1 - desired label
#   $2 - namespace
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function change_namespace_label {
  kubectl label --overwrite namespaces $2 $1 >> $SC_PROJECT_ROOT/exec.log
}

# Schedules k8s namespace along with its pods to be deleted. Does not wait for pod termination to be over.
# Accepts positional arguments:
#   $1 - namespace
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function delete_namespace {
  kubectl delete namespace --wait=false $1 >>  $SC_PROJECT_ROOT/exec.log
}

# Waits until pod is in ready state.
# Accepts positional arguments:
#   $1 - pod's label
#   $2 - namespace
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function wait_until_pod_ready {
  # Wait a little bit for pods to be found by kubectl
  sleep 2
  kubectl wait --for=condition=ready pod -l $1 -n $2 >>  $SC_PROJECT_ROOT/exec.log
}

# Waits until all pods in namespace are in ready state.
# Accepts positional arguments:
#   $1 - namespace
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function wait_until_pods_ready {
  # Wait a little bit for pods to be found by kubectl
  sleep 2
  kubectl wait --for=condition=ready pod -n $1 --all >>  $SC_PROJECT_ROOT/exec.log
}

# Installs pod security enforcement library.
# Accepts positional arguments:
#   $1 - name of the lib, valid names: 'gatekeeper' | 'kyverno' | 'kubewarden'
#   $2 - namespace
function install_enforcement_lib {
  # Validate if enforcement lib is known
  if [[ $1 != "kyverno" && $1 != "gatekeeper" && $1 != "kubewarden" ]]; then
    echo "Unknown enforcement library: '${1}' (supplied via -e parameter). Known libraries - 'kyverno', 'gatekeeper', 'kubewarden'" >&2
    exit 1
  fi

  # Install enforcement library
  bash ./$1/install.sh

  # Preprocess policies if needed before applying
  bash ./$1/policy-preprocesing.sh

  # Install associated policies
  for policy in ./$1/policies/*; do
      apply_resource $policy $2
  done

  echo "Waiting for policies to be ready"
  bash ./$1/wait-for-policies.sh
}

# Installs pod security enforcement library.
# Accepts positional arguments:
#   $1 - security profile from Pod Security Standards - valid profiles: 'privileged' | 'baseline' | 'restricted'
#   $2 - namespace
function apply_security_profile {
  # Validate if enforcement lib is known
  if [[ $1 != "privileged" && $1 != "baseline" && $1 != "restricted" ]]; then
    echo "Unknown security profile: '${1}' (supplied via -p parameter). Known profiles - 'privileged', 'baseline', 'restricted'" >&2
    exit 1
  fi

  pss_version=$(yq eval '.pssVersion' $SETTINGS_PATH)
  echo "Applying security profile - '$1' to namespace with enforce-version - $pss_version"
  change_namespace_label "pod-security.kubernetes.io/enforce=$1" $2
  change_namespace_label "pod-security.kubernetes.io/enforce-version=$pss_version" $2
}
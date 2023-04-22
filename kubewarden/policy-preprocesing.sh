#!/bin/bash

# Substitutes <<ociRegistry>> placeholder in kubewarden policies.
# Accepts positional arguments:
#   $1 - path to yml policy
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
#   $SETTINGS_PATH - path from project root to parameters yaml
function substitute_placeholders {
  local filename="$1"

  # Read the contents of the file
  local file_contents="$(cat "$filename")"

  local oci_registry=$(yq eval '.ociRegistry' $SETTINGS_PATH)

  # Replace placeholders  
  local updated_contents="${file_contents/<<ociRegistry>>/$oci_registry}"

  # Overwrite the file with the updated contents
  echo "$updated_contents" > "$filename"
}

# Does necessary kubewarden policies preprocessing
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function preprocess_kubewarden_policies {
  for policy_path in "$SC_PROJECT_ROOT"/kubewarden/policies/*; do
      substitute_placeholders $policy_path
  done
  
}

preprocess_kubewarden_policies
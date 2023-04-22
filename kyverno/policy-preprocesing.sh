#!/bin/bash

# Substitutes following placeholders in policies
#     <<namespace>>
# Accepts positional arguments:
#   $1 - path to policy
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
#   $SETTINGS_PATH - path from project root to parameters yaml
function substitute_placeholders {
  local filename="$1"

  # Read the contents of the file
  local file_contents="$(cat "$filename")"

  # Replace placeholders
  updated_contents="${file_contents/<<namespace>>/$NAMESPACE}"

  # Overwrite the file with the updated contents
  echo "$updated_contents" > "$filename"
}

# Does necessary policies preprocessing
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function preprocess_policies {
  for policy_path in "$SC_PROJECT_ROOT"/kyverno/policies/*; do
      substitute_placeholders $policy_path
  done  
}

preprocess_policies
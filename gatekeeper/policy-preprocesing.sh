#!/bin/bash

# Substitutes following placeholders in constraints
#     <<namespace>>
# Accepts positional arguments:
#   $1 - path to constraint
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

# Does necessary constraints preprocessing
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function preprocess_constraints {
  for constraint_path in "$SC_PROJECT_ROOT"/gatekeeper/constraints/*; do
      substitute_placeholders $constraint_path
  done

  for constraint_path in "$SC_PROJECT_ROOT"/gatekeeper/constraints-charts/images-can-be-referenced-only-from-allowed-registries/templates/*; do
      substitute_placeholders $constraint_path
  done
  
}

preprocess_constraints
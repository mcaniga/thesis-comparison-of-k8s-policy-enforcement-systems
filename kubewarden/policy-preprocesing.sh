#!/bin/bash

# Converts casing - eg. 'hello-world' to helloWorld
# Accepts positional arguments:
#   $1 - input string
#   $2 - path to wasm policy
function convert_policy_casing_to_wasm_casing() {
  local input_string=$1
  local output_string=""

  # Loop through each word in the input string
  for word in $(echo $input_string | tr '-' ' '); do
    # Convert the first character of each word to uppercase
    output_string="${output_string}${word^}"
  done

  # convert first character to lower case
  output_string=${output_string,}

  echo "$output_string"
}

# Substitutes <<file>> placeholder in `spec.module` in kubewarden policies.
# Accepts positional arguments:
#   $1 - path to yml policy
#   $2 - path to wasm policy
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function substitute_path_placeholder_for_absolute_path {
  local filename="$1"
  local substitution="$2"

  # Read the contents of the file
  local file_contents="$(cat "$filename")"

  # Replace the <<file>> placeholder with substitution
  local updated_contents="${file_contents/<<file>>/$substitution}"

  # Overwrite the file with the updated contents
  echo "$updated_contents" > "$filename"
}

# Does necessary kubewarden policies preprocessing
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function preprocess_kubewarden_policies {
  for policy_path in "$SC_PROJECT_ROOT"/kubewarden/policies/*; do
      local substitution="$SC_PROJECT_ROOT/kubewarden/wasm/"
      local policy_filename=$(basename $policy_path)
      local filename_without_extension="${policy_filename%.*}"
      local wasm_filename=$(convert_policy_casing_to_wasm_casing $filename_without_extension)
      local wasm_path="$SC_PROJECT_ROOT/kubewarden/wasm/$wasm_filename.wasm"
      substitute_path_placeholder_for_absolute_path $policy_path $wasm_path
  done
  
}

preprocess_kubewarden_policies
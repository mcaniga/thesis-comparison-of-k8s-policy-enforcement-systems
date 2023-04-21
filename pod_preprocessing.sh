#!/bin/bash

# Substitutes following placeholders in pods
#     <<alpineImage>>, <<alpineImageTagReferenced>>
# Accepts positional arguments:
#   $1 - path to pod
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
#   $SETTINGS_PATH - path from project root to parameters yaml
function substitute_placeholders {
  local filename="$1"

  # Read values from settings
  alpine_image=$(yq eval '.alpineImage' $SETTINGS_PATH)
  alpine_image_empty_tag=$(yq eval '.alpineImageEmptyTag' $SETTINGS_PATH)
  alpine_image_tag_referenced=$(yq eval '.alpineImageTagReferenced' $SETTINGS_PATH)

  # Read the contents of the file
  local file_contents="$(cat "$filename")"

  # Replace placeholders
  updated_contents="${file_contents/<<alpineImage>>/$alpine_image}"
  updated_contents="${updated_contents/<<alpineImageEmptyTag>>/$alpine_image_empty_tag}"
  updated_contents="${updated_contents/<<alpineImageTagReferenced>>/$alpine_image_tag_referenced}"

  # Overwrite the file with the updated contents
  echo "$updated_contents" > "$filename"
}

# Does necessary pod preprocessing
# Uses global variable:
#   $SC_PROJECT_ROOT - path to the project root
function preprocess_pods {
  for pod_path in "$SC_PROJECT_ROOT"/pods/secure/*; do
      substitute_placeholders $pod_path
  done

  for pod_path in "$SC_PROJECT_ROOT"/pods/vulnerable/*; do
      substitute_placeholders $pod_path
  done
  
}

preprocess_pods
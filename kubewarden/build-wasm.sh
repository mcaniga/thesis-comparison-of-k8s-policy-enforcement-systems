#!/bin/bash

cd ./rego
for filename in *; do
    # Strip .rego from filename
    POLICY_NAME=$(echo $filename | cut -f1 -d".")
    # Build .wasm from rego
    opa build -t wasm -e $POLICY_NAME/violation $POLICY_NAME.rego
    # Extract wasm policy from generated tar
    tar -xf bundle.tar.gz /policy.wasm
    WASM_NAME=$(echo $POLICY_NAME | sed 's/\([a-z]\)\([A-Z]\)/\1-\2/g' | tr '[:upper:]' '[:lower:]')
    # Move wasm policy to wasm folder
    mv ./policy.wasm ../wasm/$WASM_NAME.wasm
    # Cleanup
    rm bundle.tar.gz
done
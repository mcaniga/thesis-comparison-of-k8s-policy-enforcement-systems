#!/bin/bash

## Instals `opa` on linux machine. Used for compiling the rego policies to wasm for kubewarden

# Download the OPA binary
curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64

# Make the binary executable
chmod 755 opa

# Move the binary to /usr/local/bin
sudo mv opa /usr/local/bin/
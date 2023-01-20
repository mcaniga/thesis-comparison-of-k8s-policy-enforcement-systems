#!/bin/bash

# TODO: add detection if gatekeeper is already installed - presence of namespace `gatekeeper-system`
# TODO: use helm?
# TODO: version can be specified also without helm, can't use 'master' in final form of thesis

kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
# Master Thesis - Comparison of k8s policy enforcement systems

- implementation part of master thesis
- tool for checking of cluster security through deployment of vulnerable pods
- tool also provides additional ability to install Kyverno, OPA Gatekeeper and Kubewarden policies and apply Pod Security Profiles, to fix the security problems and enforce relevant security settings - list of relevant security settings is in `docs/policies.md`
- NOTE: **pod convention** - pod filename must match its `metadata.name` to correctly indentify if pod was applied to cluster

## Supported Kubernetes versions
- 1.26
- (TODO: will be tested on older versions, divide support to features )

## Prerequisites
- access to Kubernetes cluster and kubectl
- bash
- Helm v3 (tested on v3.6.3)
  - installation - https://helm.sh/docs/intro/install/

## Recomended testing environment
- script can be used in existing cluster
- for testing, run script in  **free KillerCoda Kubernetes 1.26** environment 
  - https://killercoda.com/playgrounds/scenario/kubernetes

## Quick setup
1. Clone repository
  - `git clone https://github.com/mcaniga/thesis-comparison-of-k8s-policy-enforcement-systems.git`
2. Execute security check
  - `bash apply.sh -n cluster-security-check`

## Usage
- execute security test
```
bash apply.sh -n test
```
- enforce Pod Security Standards
```
bash apply.sh -n test -p privileged
```
- install policies with specified enforcement library
```
bash apply.sh -n test -e kyverno
```
- documentation regarding parameters can be found in `docs/parameters.md`

- pods defined in `/pods/secure` are considered secure and must pass the policy checks - to ensure that policy is not simply rejecting all pods
- pods defined in `/pods/vulnerable` are considered insecure and should not pass the policy checks (may with mutating controller, but that is TODO)

## Examples
- see `docs/responses.md`
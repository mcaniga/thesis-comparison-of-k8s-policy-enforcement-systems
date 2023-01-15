# Master Thesis - Comparison of k8s policy enforcement systems

- implementation part of master thesis
- tool for checking of cluster security through deployment of vulnerable pods
- NOTE: **pod convention** - pod filename must match its `metadata.name` to correctly indentify if pod was applied to cluster
- tested on Kubernetes 1.26

## Quick setup
- apply script either to k8s existing cluster or try free KillerCoda Kubernetes 1.26 environment - https://killercoda.com/playgrounds/scenario/kubernetes
- `git clone https://github.com/mcaniga/thesis-comparison-of-k8s-policy-enforcement-systems.git`
- `bash apply.sh -n cluster-security-check`

## Workflow
- to run the cluster security test, user should execute the `apply.sh` script
  - `bash apply.sh -n <namespace>`
    - `-n <namespace>` 
      - determines in which namespace the test will be executed
      - if argument is missing, test will run in generated namespace 
      - if provided namespace does not exist, it will be created
- pods defined in `/pods/secure` are considered secure and must pass the policy checks - to ensure that policy is not simply rejecting all pods
- pods defined in `/pods/vulnerable` are considered insecure and should not pass the policy checks (may with mutating controller, but that is TODO)
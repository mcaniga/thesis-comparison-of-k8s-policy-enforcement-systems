# Master Thesis - Comparison of k8s policy enforcement systems

- implementation part of master thesis
- tool for checking of cluster security through deployment of vulnerable pods

## Workflow
- to run the cluster security test, user should execute the `apply.sh` script
- pods defined in `/pods/secure` are considered secure and must pass the policy checks - to ensure that policy is not simply rejecting all pods
- pods defined in `/pods/vulnerable` are considered insecure and should not pass the policy checks (may with mutating controller, but that is TODO)
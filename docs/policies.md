# Policies
List of policies that will be enforced in cluster, if enforcement library or profile will be chosen.
For secure clusters, enforce Pod Security Standards restricted profile with `-p restricted` and provide additional policies not provided by PSS, via Kyverno, Gatekeeper or Kubewarden

| Enfocement library | -e argument | Description                                |
|--------------------|-------------|--------------------------------------------|
| Kyverno            | kyverno     | Kyverno policies will be installed.        |
| OPA Gatekeeper     | gatekeeper  | OPA Gatekeeper policies will be installed. |
| Kubewarden         | kubewarden  | Kubewarden policies will be installed.     |

- policies implemented in this tool for given enforcement library

| Policy               | kyverno  | gatekeeper | kubewarden |
|----------------------|----------|------------|------------|
| Read Only Filesystem | &#x2611; | &#x2611;   | &#x2611;   |
todo: add policies for rules from thesis


## Pod Security Standards 
- enforced by `-p` parameter

 | -p argument | Description                                                                |
 |-------------|----------------------------------------------------------------------------|
 | privileged  | No policy will be enforced.                                                |
 | baseline    | Minimally restrictive policy which prevents known privilege escalations.   |
 | restricted  | Heavily restricted policy, following current Pod hardening best practices. |

- profiles are enforced via built-in Pod Security Admission controller - https://kubernetes.io/docs/concepts/security/pod-security-admission/
- more information about Pod Security Standards - https://kubernetes.io/docs/concepts/security/pod-security-standards/
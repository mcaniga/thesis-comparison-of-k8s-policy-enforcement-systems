# Policies
List of policies that will be enforced in cluster, if enforcement library or profile will be chosen.
For secure clusters, enforce Pod Security Standards restricted profile with `-p restricted` and provide additional policies not provided by PSS, via Kyverno, Gatekeeper or Kubewarden

## Kyverno
- enforced by `-e kyverno` parameter
- enforced policies
  - read only filesystem

## OPA Gatekeeper
- enforced by `-e gatekeeper` parameter
- enforced policies
  - read only filesystem

## Kubewarden
- enforced by `-e kubewarden` parameter
- enforced policies
  - read only filesystem

## Pod Security Standards 
- enforced by `-p` parameter

 | -p argument | Description                                                                |
 |-------------|----------------------------------------------------------------------------|
 | restricted  | No policy will be enforced.                                                |
 | baseline    | Minimally restrictive policy which prevents known privilege escalations.   |
 | privileged  | Heavily restricted policy, following current Pod hardening best practices. |

- profiles are enforced via built-in Pod Security Admission controller - https://kubernetes.io/docs/concepts/security/pod-security-admission/
- more information about Pod Security Standards - https://kubernetes.io/docs/concepts/security/pod-security-standards/
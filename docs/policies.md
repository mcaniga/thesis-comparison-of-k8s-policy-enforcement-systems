# Policies
List of policies that will be enforced in cluster, if enforcement library or profile will be chosen.
For secure clusters, enforce Pod Security Standards restricted profile with `-p restricted` and provide additional policies not provided by PSS, via Kyverno, Gatekeeper or Kubewarden

| Enfocement library | -e argument | Description                                |
|--------------------|-------------|--------------------------------------------|
| Kyverno            | kyverno     | Kyverno policies will be installed.        |
| OPA Gatekeeper     | gatekeeper  | OPA Gatekeeper policies will be installed. |
| Kubewarden         | kubewarden  | Kubewarden policies will be installed.     |

- policies implemented in this tool for given enforcement library

| Policy               | kyverno  | gatekeeper | kubewarden |  additional text |
|----------------------|----------|------------|------------|------------------|
| Root filesystem is readonly | &#x2611; | &#x2611;   | &#x2611;   | |
| CPU limits are set (TODO: implement) | &#x2611;   | &#x2611;   | Kyverno does not support parametrization |
| Memory limits are set (TODO: implement) | &#x2611;   | &#x2611;   | Kyverno does not support parametrization |
| CPU requests are set (TODO: implement) | &#x2611;   | &#x2611;   | Kyverno does not support parametrization |
| Memory requests are set (TODO: implement) | &#x2611;   | &#x2611;   | Kyverno does not support parametrization |
| Image can be referenced only with image digest (TODO: implement, add vulnerable pod) | &#x2611;   | &#x2611;   |  |
| UID under 10000 is forbidden (TODO: implement, add vulnerable pod) | &#x2611;  | &#x2611;   | &#x2611;   |  |
| Liveness probes are set (TODO: implement, add vulnerable pod) | &#x2611;  | &#x2611;   | &#x2611;   |  |
| Readiness probes are set (TODO: implement, add vulnerable pod) | &#x2611;  | &#x2611;   | &#x2611;   |  |
| Always pull image (TODO: implement, add vulnerable pod) | &#x2611;  | &#x2611;   | &#x2611;   |  |
| Images can be referenced only from allowed registries (TODO: implement, add vulnerable pod) | &#x2611; |  | &#x2611;   | &#x2611;   | Kyverno does not support parametrization. Imperative operations with value cannot be done in Kyverno.  |


- policies implemented by PSS profiles

| Policy               | Profile  |
|----------------------|----------|
| Host path cannot be mounted | baseline |
| Docker socket cannot be mounted | baseline - HostPath Volumes |
| Priviledged containers are disallowed | baseline |
| Sharing of PID namespaces is disallowed | baseline |
| Sharing of IPC namespaces is disallowed | baseline |
| Sharing of network namespaces is disallowed | baseline |
| Priviledged escalation is disallowed | restricted |
| runAsNonRoot is set to true | restricted |
| Containers cannot set runAsUser to 0 | restricted |
| Disabling seccomp with Unconfined profile type is disallowed | restricted |
| All capabilities are dropped, with exception of NET_BIND_SERVICE | restricted |



## Pod Security Standards 
- enforced by `-p` parameter

 | -p argument | Description                                                                |
 |-------------|----------------------------------------------------------------------------|
 | privileged  | No policy will be enforced.                                                |
 | baseline    | Minimally restrictive policy which prevents known privilege escalations.   |
 | restricted  | Heavily restricted policy, following current Pod hardening best practices. |

- profiles are enforced via built-in Pod Security Admission controller - https://kubernetes.io/docs/concepts/security/pod-security-admission/
- more information about Pod Security Standards - https://kubernetes.io/docs/concepts/security/pod-security-standards/
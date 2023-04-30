# List of known responses
- document specifies known and tested responses of the tool with `apply.sh` as entrypoint
- can be used for manual testing

## Validation

### Without parameters
- **input**
```
controlplane $ bash apply.sh
```
- **output**
```
-------------------------------
Starting cluster security check
-------------------------------
Namespace (-n) is required
```

### Missing namespace argument
- **input**
```
controlplane $ bash apply.sh -n
```
- **output**
```
-------------------------------
Starting cluster security check
-------------------------------
apply.sh: option requires an argument -- n
Namespace (-n) is required
```

### Unknown enforcement library
- **input**
```
controlplane $ bash apply.sh -n test -e unknownlib
```
- **output**
```
-------------------------------
Starting cluster security check
-------------------------------
Using existing namespace: 'test'
Unknown enforcement library: 'aaa' (supplied via -e parameter). Known libraries - 'kyverno', 'gatekeeper', 'kubewarden'
```

### Unknown security profile
- **input**
```
controlplane $ bash apply.sh -n test -p aaa
```

- **output**
```
-------------------------------
Starting cluster security check
-------------------------------
Creating namespace test
Unknown security profile: 'aaa' (supplied via -p parameter). Known profiles - 'privileged', 'baseline', 'restricted'
```

## "Good case" scenarios

### Cluster security check - new namespace, without installed policies
- **input**
```
controlplane $ bash apply.sh -n test -s ./example-settings.yaml
```

- **output**
```
-------------------------------
Starting cluster security check
-------------------------------
Creating namespace test

Applying vulnerable pods...

Applying secure pods...
-------------------------------
Results
-------------------------------
Successfull: 1/30
Unsuccessfull: 29/30
Safe pods accepted:
secure-pod

Risky pods rejected:

Risky pods accepted:
0. Description: Pod without dropped capabilities, but added kill capability ||| Risk Reason: Container process can kill other processes. If KILL capability can be added, there is a risk that other capabilities can be added too. 

1. Description: Container without set CPU limits ||| Risk Reason: Container can consume all of host CPU cores, and cause resource starvation for other pods. 

2. Description: Container without set CPU requests ||| Risk Reason: If CPU requests are not set, other misbehaving pod can cause resource starvation for this pod. 

3. Description: Pod without dropped capabilities ||| Risk Reason: Compromised container process will have default parts of root permissions (capabilities) 

4. Description: Container with dummy image registry ||| Risk Reason: Image registry is unrestricted, higher risk of malicious images. Pull images only from registries you can trust. 

5. Description: Container with empty tag ||| Risk Reason: Pod can run new version of image on restarts. The version can be malicious or with breaking changes. Same as usage of latest tag. 

6. Description: Container has imagePullPolicy set to IfNotPresent ||| Risk Reason: Attacker can poison local registry, thus malicious image will be loaded. 

7. Description: Container has imagePullPolicy set to Never ||| Risk Reason: Attacker can poison local registry, thus malicious image will be loaded. 

8. Description: Container with image referenced by tag ||| Risk Reason: Attacker can poison local registry, thus malicious image will be loaded. Instead, reference image by digest. 

9. Description: Pod with shared IPC namespace ||| Risk Reason: Container process has access to host interprocess comunication resources and can potentially manipulate with them - eg. communicate with host using shared memory 

10. Description: Container with latest tag ||| Risk Reason: Pod can run new version of image on restarts. The version can be malicious or with breaking changes. 

11. Description: Container has not set liveness probe ||| Risk Reason: Without correct liveness probe, container can be in ill-state and not be restarted. 

12. Description: Container without set memory limits ||| Risk Reason: Container can consume all of host memory, and cause resource starvation for other pods. 

13. Description: Container without set memory requests ||| Risk Reason: If memory requests are not set, other misbehaving container can cause resource starvation for this pod. 

14. Description: Pod with mounted docker socket ||| Risk Reason: Attacker can manipulate with Docker on host from container via socket. Attacket can manipulate with images on host, eg. stop them and cause DoS, or break from container via creation of privileged container. 

15. Description: Pod with host mount ||| Risk Reason: Host mount exposes files or directories from host filesystem. Attacker can read, modify or delete this information from container (only read if readOnly). Violates all three attributes of CIA triad (only confidentiality if readOnly). 

16. Description: Pod with shared network namespace ||| Risk Reason: Container process has access to network namespace of host, which can be abused eg. for network traffic snooping 

17. Description: Pod with shared PID namespace ||| Risk Reason: Container process has access to host processes and can potentially manipulate with them. 

18. Description: Pod without allowPrivilegeEscalation field. ||| Risk Reason: Process can obtain higher privileges than parent process 

19. Description: Pod with allowPrivilegeEscalation field set to true. ||| Risk Reason: Process can obtain higher privileges than parent process 

20. Description: Pod with privileged field set to true. ||| Risk Reason: Containers run without any isolation from host. 

21. Description: Container has not set readiness probe ||| Risk Reason: Without readiness probe, traffic will be sent to pod that is just inicializing, causing undesirable behaviour. 

22. Description: Pod with runAsNonRoot field set to false. ||| Risk Reason: Processes will be run under root user 

23. Description: Pod without runAsNonRoot field. ||| Risk Reason: Processes will be run under root user 

24. Description: Pod with runAsUser field set to 1000. ||| Risk Reason: UID of container user can clash with user on host machine, and reference priviledged user. 

25. Description: Pod with runAsUser field set to zero. ||| Risk Reason: Processes will be run under root user 

26. Description: Pod without disabled seccomp via Unconfined seccomp type ||| Risk Reason: Seccomp filters configured system calls. Disabling seccomp allows unrestricted access to system calls for container processes. 

27. Description: Pod without any security context or security settings. ||| Risk Reason: It is possible to deploy pod to your cluster without any security settings or security settings 

28. Description: Pod with readOnlyRootFilesystem set to false ||| Risk Reason: Container process can manipulate with filesystem, modify and delete important files, eg. configuration 


Safe pods rejected:
```

### Cluster security check - new namespace, Kyverno as policy enforcement
- **input**
```
controlplane $ bash apply.sh -n test -e kyverno -s ./example-settings.yaml
```

- **output**
```
-------------------------------
Starting cluster security check
-------------------------------
Creating namespace test
Installing Kyverno release-1.7 in Standalone mode
For production installation, use 'helm' package manager for Kubernetes, specify exact version, and set at least 3 replicas.
Installing Kyverno release-1.7 ...
Waiting for policies to be ready

Applying vulnerable pods...
Error from server: error when creating "cpu-limits-are-not-set.yml": admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Pod/test/cpu-limits-are-not-set was blocked due to the following policies

limits-and-requests-are-required:
  limits-and-requests-are-required-rule: 'validation error: CPU and memory resource
    requests and limits are required. Rule limits-and-requests-are-required-rule failed
    at path /spec/containers/0/resources/limits/cpu/'
Error from server: error when creating "cpu-requests-are-not-set.yml": admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Pod/test/cpu-requests-are-not-set was blocked due to the following policies

limits-and-requests-are-required:
  limits-and-requests-are-required-rule: 'validation error: CPU and memory resource
    requests and limits are required. Rule limits-and-requests-are-required-rule failed
    at path /spec/containers/0/resources/requests/cpu/'
Error from server: error when creating "empty-tag.yml": admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Pod/test/empty-tag was blocked due to the following policies

image-can-be-referenced-only-with-image-digest:
  image-can-be-referenced-only-with-image-digest-rule: 'validation error: Referencing
    images via tags is not allowed, instead use image digests. Rule image-can-be-referenced-only-with-image-digest-rule
    failed at path /spec/containers/0/image/'
Error from server: error when creating "image-pull-policy-if-not-present.yml": admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Pod/test/image-pull-policy-if-not-present was blocked due to the following policies

always-pull-image-from-remote-registry:
  always-pull-image-from-remote-registry-rule: 'validation failure: validation error:
    The imagePullPolicy must be set to `Always`. Rule always-pull-image-from-remote-registry-rule
    failed at path /imagePullPolicy/'
Error from server: error when creating "image-pull-policy-never.yml": admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Pod/test/image-pull-policy-never was blocked due to the following policies

always-pull-image-from-remote-registry:
  always-pull-image-from-remote-registry-rule: 'validation failure: validation error:
    The imagePullPolicy must be set to `Always`. Rule always-pull-image-from-remote-registry-rule
    failed at path /imagePullPolicy/'
Error from server: error when creating "image-tag.yml": admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Pod/test/image-tag was blocked due to the following policies

image-can-be-referenced-only-with-image-digest:
  image-can-be-referenced-only-with-image-digest-rule: 'validation error: Referencing
    images via tags is not allowed, instead use image digests. Rule image-can-be-referenced-only-with-image-digest-rule
    failed at path /spec/containers/0/image/'
Error from server: error when creating "latest-tag.yml": admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Pod/test/latest-tag was blocked due to the following policies

image-can-be-referenced-only-with-image-digest:
  image-can-be-referenced-only-with-image-digest-rule: 'validation error: Referencing
    images via tags is not allowed, instead use image digests. Rule image-can-be-referenced-only-with-image-digest-rule
    failed at path /spec/containers/0/image/'
Error from server: error when creating "liveness-probe-is-not-set.yml": admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Pod/test/liveness-probe-is-not-set was blocked due to the following policies

liveness-probes-are-required:
  liveness-probes-are-required-rule: 'validation failure: Liveness probes are required
    for all containers.'
Error from server: error when creating "memory-limits-are-not-set.yml": admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Pod/test/memory-limits-are-not-set was blocked due to the following policies

limits-and-requests-are-required:
  limits-and-requests-are-required-rule: 'validation error: CPU and memory resource
    requests and limits are required. Rule limits-and-requests-are-required-rule failed
    at path /spec/containers/0/resources/limits/memory/'
Error from server: error when creating "memory-requests-are-not-set.yml": admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Pod/test/memory-requests-are-not-set was blocked due to the following policies

limits-and-requests-are-required:
  limits-and-requests-are-required-rule: 'validation error: CPU and memory resource
    requests and limits are required. Rule limits-and-requests-are-required-rule failed
    at path /spec/containers/0/resources/limits/memory/'
Error from server: error when creating "priviledge-escalation-missing.yml": admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Pod/test/priviledge-escalation-missing was blocked due to the following policies

uid-under-10000-is-forbidden:
  uid-under-10000-is-forbidden-rule: 'validation error: UID in runAsUser must be at
    least 10000. Rule uid-under-10000-is-forbidden-rule failed at path /spec/containers/0/securityContext/runAsUser/'
Error from server: error when creating "privileged-containers.yml": admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Pod/test/privileged-containers was blocked due to the following policies

uid-under-10000-is-forbidden:
  uid-under-10000-is-forbidden-rule: 'validation error: UID in runAsUser must be at
    least 10000. Rule uid-under-10000-is-forbidden-rule failed at path /spec/containers/0/securityContext/runAsUser/'
Error from server: error when creating "readiness-probe-is-not-set.yml": admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Pod/test/readiness-probe-is-not-set was blocked due to the following policies

readiness-probes-are-required:
  readiness-probes-are-required-rule: 'validation failure: Readiness probes are required
    for all containers.'
Error from server: error when creating "run-as-user-1000.yml": admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Pod/test/run-as-user-1000 was blocked due to the following policies

uid-under-10000-is-forbidden:
  uid-under-10000-is-forbidden-rule: 'validation error: UID in runAsUser must be at
    least 10000. Rule uid-under-10000-is-forbidden-rule failed at path /spec/containers/0/securityContext/runAsUser/'
Error from server: error when creating "run-as-user-zero.yml": admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Pod/test/run-as-user-zero was blocked due to the following policies

uid-under-10000-is-forbidden:
  uid-under-10000-is-forbidden-rule: 'validation error: UID in runAsUser must be at
    least 10000. Rule uid-under-10000-is-forbidden-rule failed at path /spec/containers/0/securityContext/runAsUser/'
Error from server: error when creating "without-security-context.yml": admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Pod/test/without-security-context was blocked due to the following policies

image-can-be-referenced-only-with-image-digest:
  image-can-be-referenced-only-with-image-digest-rule: 'validation error: Referencing
    images via tags is not allowed, instead use image digests. Rule image-can-be-referenced-only-with-image-digest-rule
    failed at path /spec/containers/0/image/'
limits-and-requests-are-required:
  limits-and-requests-are-required-rule: 'validation error: CPU and memory resource
    requests and limits are required. Rule limits-and-requests-are-required-rule failed
    at path /spec/containers/0/resources/limits/'
root-filesystem-is-readonly:
  root-filesystem-is-readonly-rule: 'validation error: Root filesystem must be read-only.
    Rule root-filesystem-is-readonly-rule failed at path /spec/containers/0/securityContext/'
uid-under-10000-is-forbidden:
  uid-under-10000-is-forbidden-rule: 'validation error: UID in runAsUser must be at
    least 10000. Rule uid-under-10000-is-forbidden-rule failed at path /spec/containers/0/securityContext/'
Error from server: error when creating "writable-root-filesystem.yml": admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Pod/test/writable-root-filesystem was blocked due to the following policies

root-filesystem-is-readonly:
  root-filesystem-is-readonly-rule: 'validation error: Root filesystem must be read-only.
    Rule root-filesystem-is-readonly-rule failed at path /spec/containers/0/securityContext/readOnlyRootFilesystem/'

Applying secure pods...
-------------------------------
Results
-------------------------------
Successfull: 18/30
Unsuccessfull: 12/30
Safe pods accepted:
secure-pod

Risky pods rejected:
cpu-limits-are-not-set
cpu-requests-are-not-set
empty-tag
image-pull-policy-if-not-present
image-pull-policy-never
image-tag
latest-tag
liveness-probe-is-not-set
memory-limits-are-not-set
memory-requests-are-not-set
priviledge-escalation-missing
privileged-containers
readiness-probe-is-not-set
run-as-user-1000
run-as-user-zero
without-security-context
writable-root-filesystem

Risky pods accepted:
0. Description: Pod without dropped capabilities, but added kill capability ||| Risk Reason: Container process can kill other processes. If KILL capability can be added, there is a risk that other capabilities can be added too. 

1. Description: Pod without dropped capabilities ||| Risk Reason: Compromised container process will have default parts of root permissions (capabilities) 

2. Description: Container with dummy image registry ||| Risk Reason: Image registry is unrestricted, higher risk of malicious images. Pull images only from registries you can trust. 

3. Description: Pod with shared IPC namespace ||| Risk Reason: Container process has access to host interprocess comunication resources and can potentially manipulate with them - eg. communicate with host using shared memory 

4. Description: Pod with mounted docker socket ||| Risk Reason: Attacker can manipulate with Docker on host from container via socket. Attacket can manipulate with images on host, eg. stop them and cause DoS, or break from container via creation of privileged container. 

5. Description: Pod with host mount ||| Risk Reason: Host mount exposes files or directories from host filesystem. Attacker can read, modify or delete this information from container (only read if readOnly). Violates all three attributes of CIA triad (only confidentiality if readOnly). 

6. Description: Pod with shared network namespace ||| Risk Reason: Container process has access to network namespace of host, which can be abused eg. for network traffic snooping 

7. Description: Pod with shared PID namespace ||| Risk Reason: Container process has access to host processes and can potentially manipulate with them. 

8. Description: Pod with allowPrivilegeEscalation field set to true. ||| Risk Reason: Process can obtain higher privileges than parent process 

9. Description: Pod with runAsNonRoot field set to false. ||| Risk Reason: Processes will be run under root user 

10. Description: Pod without runAsNonRoot field. ||| Risk Reason: Processes will be run under root user 

11. Description: Pod without disabled seccomp via Unconfined seccomp type ||| Risk Reason: Seccomp filters configured system calls. Disabling seccomp allows unrestricted access to system calls for container processes. 


Safe pods rejected:
```

### Cluster security check - new namespace, Gatekeeper as policy enforcement
- **input**
```
controlplane $ bash apply.sh -n test -e gatekeeper -s ./example-settings.yaml
```

- **output**
```
-------------------------------
Starting cluster security check
-------------------------------
Creating namespace test
Installing OPA Gatekeeper - release-3.11 ...
Waiting for policies to be ready
Applying non parametric constraints
Non parametric constraints applied
Applying parametric constraints
NAME: images-can-be-referenced-only-from-allowed-registries
LAST DEPLOYED: Sun Apr 30 08:51:08 2023
NAMESPACE: test
STATUS: deployed
REVISION: 1
TEST SUITE: None
Parametric constraints applied

Applying vulnerable pods...
Error from server (Forbidden): error when creating "cpu-limits-are-not-set.yml": admission webhook "validation.gatekeeper.sh" denied the request: [limitsandrequestsarerequired] container <cpu-limits-are-not-set-container> has not specified cpu limits
Error from server (Forbidden): error when creating "cpu-requests-are-not-set.yml": admission webhook "validation.gatekeeper.sh" denied the request: [limitsandrequestsarerequired] container <cpu-requests-are-not-set-container> has not specified cpu limits
[limitsandrequestsarerequired] container <cpu-requests-are-not-set-container> has not specified cpu requests
Error from server (Forbidden): error when creating "dummy-image-registry.yml": admission webhook "validation.gatekeeper.sh" denied the request: [imagescanbereferencedonlyfromallowedregistries] container <dummy-image-registry-container> has an invalid image repo <harbor-untrusted-org.local/dummy_registry/alpine@sha256:b6ca290b6b4cdcca5b3db3ffa338ee0285c11744b4a6abaa9627746ee3291d8d>, allowed repos are ["harbor-trusted-org.local/ harbor-partially-trusted-org.local/trusted_repo/"]
Error from server (Forbidden): error when creating "empty-tag.yml": admission webhook "validation.gatekeeper.sh" denied the request: [imagecanbereferencedonlywithimagedigest] container  <empty-tag-container> must reference image by digest
Error from server (Forbidden): error when creating "image-pull-policy-if-not-present.yml": admission webhook "validation.gatekeeper.sh" denied the request: [alwayspullimagefromremoteregistry] container <image-pull-policy-if-not-present-container> has not set imagePullPolicy to Always
Error from server (Forbidden): error when creating "image-pull-policy-never.yml": admission webhook "validation.gatekeeper.sh" denied the request: [alwayspullimagefromremoteregistry] container <image-pull-policy-never-container> has not set imagePullPolicy to Always
Error from server (Forbidden): error when creating "image-tag.yml": admission webhook "validation.gatekeeper.sh" denied the request: [imagecanbereferencedonlywithimagedigest] container  <image-tag-container> must reference image by digest
Error from server (Forbidden): error when creating "latest-tag.yml": admission webhook "validation.gatekeeper.sh" denied the request: [imagecanbereferencedonlywithimagedigest] container  <latest-tag-container> must reference image by digest
Error from server (Forbidden): error when creating "liveness-probe-is-not-set.yml": admission webhook "validation.gatekeeper.sh" denied the request: [livenessprobesarerequired] liveness probes are not configured in container <liveness-probe-is-not-set-container>
Error from server (Forbidden): error when creating "memory-limits-are-not-set.yml": admission webhook "validation.gatekeeper.sh" denied the request: [limitsandrequestsarerequired] container <memory-limits-are-not-set-container> has not specified memory limits
Error from server (Forbidden): error when creating "memory-requests-are-not-set.yml": admission webhook "validation.gatekeeper.sh" denied the request: [limitsandrequestsarerequired] container <memory-requests-are-not-set-container> has not specified memory limits
[limitsandrequestsarerequired] container <memory-requests-are-not-set-container> has not specified memory requests
Error from server (Forbidden): error when creating "priviledge-escalation-missing.yml": admission webhook "validation.gatekeeper.sh" denied the request: [uidunder10000isforbidden] uuid must be under 10000 in container <priviledge-escalation-missing-container>
Error from server (Forbidden): error when creating "privileged-containers.yml": admission webhook "validation.gatekeeper.sh" denied the request: [uidunder10000isforbidden] uuid must be under 10000 in container <privileged-containers-container>
Error from server (Forbidden): error when creating "readiness-probe-is-not-set.yml": admission webhook "validation.gatekeeper.sh" denied the request: [readinessprobesarerequired] readiness probes are not configured in container <readiness-probe-is-not-set-container>
Error from server (Forbidden): error when creating "run-as-user-1000.yml": admission webhook "validation.gatekeeper.sh" denied the request: [uidunder10000isforbidden] uuid must be under 10000 in container <run-as-user-1000-container>
Error from server (Forbidden): error when creating "run-as-user-zero.yml": admission webhook "validation.gatekeeper.sh" denied the request: [uidunder10000isforbidden] uuid must be under 10000 in container <run-as-user-zero-container>
Error from server (Forbidden): error when creating "without-security-context.yml": admission webhook "validation.gatekeeper.sh" denied the request: [imagecanbereferencedonlywithimagedigest] container  <without-security-context-container> must reference image by digest
[limitsandrequestsarerequired] container <without-security-context-container> has not specified cpu limits
[limitsandrequestsarerequired] container <without-security-context-container> has not specified cpu requests
[limitsandrequestsarerequired] container <without-security-context-container> has not specified memory limits
[limitsandrequestsarerequired] container <without-security-context-container> has not specified memory requests
[uidunder10000isforbidden] uuid must be under 10000 in container <without-security-context-container>

Applying secure pods...
-------------------------------
Results
-------------------------------
Successfull: 18/30
Unsuccessfull: 12/30
Safe pods accepted:
secure-pod

Risky pods rejected:
cpu-limits-are-not-set
cpu-requests-are-not-set
dummy-image-registry
empty-tag
image-pull-policy-if-not-present
image-pull-policy-never
image-tag
latest-tag
liveness-probe-is-not-set
memory-limits-are-not-set
memory-requests-are-not-set
priviledge-escalation-missing
privileged-containers
readiness-probe-is-not-set
run-as-user-1000
run-as-user-zero
without-security-context

Risky pods accepted:
0. Description: Pod without dropped capabilities, but added kill capability ||| Risk Reason: Container process can kill other processes. If KILL capability can be added, there is a risk that other capabilities can be added too. 

1. Description: Pod without dropped capabilities ||| Risk Reason: Compromised container process will have default parts of root permissions (capabilities) 

2. Description: Pod with shared IPC namespace ||| Risk Reason: Container process has access to host interprocess comunication resources and can potentially manipulate with them - eg. communicate with host using shared memory 

3. Description: Pod with mounted docker socket ||| Risk Reason: Attacker can manipulate with Docker on host from container via socket. Attacket can manipulate with images on host, eg. stop them and cause DoS, or break from container via creation of privileged container. 

4. Description: Pod with host mount ||| Risk Reason: Host mount exposes files or directories from host filesystem. Attacker can read, modify or delete this information from container (only read if readOnly). Violates all three attributes of CIA triad (only confidentiality if readOnly). 

5. Description: Pod with shared network namespace ||| Risk Reason: Container process has access to network namespace of host, which can be abused eg. for network traffic snooping 

6. Description: Pod with shared PID namespace ||| Risk Reason: Container process has access to host processes and can potentially manipulate with them. 

7. Description: Pod with allowPrivilegeEscalation field set to true. ||| Risk Reason: Process can obtain higher privileges than parent process 

8. Description: Pod with runAsNonRoot field set to false. ||| Risk Reason: Processes will be run under root user 

9. Description: Pod without runAsNonRoot field. ||| Risk Reason: Processes will be run under root user 

10. Description: Pod without disabled seccomp via Unconfined seccomp type ||| Risk Reason: Seccomp filters configured system calls. Disabling seccomp allows unrestricted access to system calls for container processes. 

11. Description: Pod with readOnlyRootFilesystem set to false ||| Risk Reason: Container process can manipulate with filesystem, modify and delete important files, eg. configuration 


Safe pods rejected:
```

### Cluster security check - new namespace, Kubewarden as policy enforcement
- **input**
```
controlplane $ bash apply.sh -n test -e kubewarden -s ./example-settings.yaml
```

- **output**
```
-------------------------------
Starting cluster security check
-------------------------------
Creating namespace test
Installing kubewarden (cert-manager - v1.11.1, crds - 1.3.0, controller - 1.5.0, defaults - 1.6.0)...
Waiting for cert manager...
Waiting for crds...
Waiting for controller...
Waiting for defaults...
Waiting for policies to be ready

Applying vulnerable pods...
Error from server: error when creating "cpu-limits-are-not-set.yml": admission webhook "clusterwide-limits-and-requests-are-required.kubewarden.admission" denied the request: container has not specified cpu limits
Error from server: error when creating "cpu-requests-are-not-set.yml": admission webhook "clusterwide-limits-and-requests-are-required.kubewarden.admission" denied the request: container has not specified cpu requests, container has not specified cpu limits
Error from server: error when creating "dummy-image-registry.yml": admission webhook "clusterwide-images-can-be-referenced-only-from-allowed-registries.kubewarden.admission" denied the request: container has an invalid image repo
Error from server: error when creating "empty-tag.yml": admission webhook "clusterwide-image-can-be-referenced-only-with-image-digest.kubewarden.admission" denied the request: container must reference image by digest
Error from server: error when creating "image-pull-policy-if-not-present.yml": admission webhook "clusterwide-always-pull-image-from-remote-registry.kubewarden.admission" denied the request: imagePullPolicy should be always
Error from server: error when creating "image-pull-policy-never.yml": admission webhook "clusterwide-always-pull-image-from-remote-registry.kubewarden.admission" denied the request: imagePullPolicy should be always
Error from server: error when creating "image-tag.yml": admission webhook "clusterwide-image-can-be-referenced-only-with-image-digest.kubewarden.admission" denied the request: container must reference image by digest
Error from server: error when creating "latest-tag.yml": admission webhook "clusterwide-image-can-be-referenced-only-with-image-digest.kubewarden.admission" denied the request: container must reference image by digest
Error from server: error when creating "liveness-probe-is-not-set.yml": admission webhook "clusterwide-liveness-probes-are-required.kubewarden.admission" denied the request: liveness probes are not configured in container
Error from server: error when creating "memory-limits-are-not-set.yml": admission webhook "clusterwide-limits-and-requests-are-required.kubewarden.admission" denied the request: container has not specified memory limits
Error from server: error when creating "memory-requests-are-not-set.yml": admission webhook "clusterwide-limits-and-requests-are-required.kubewarden.admission" denied the request: container has not specified memory limits, container has not specified memory requests
Error from server: error when creating "priviledge-escalation-missing.yml": admission webhook "clusterwide-uid-under-10000-is-forbidden.kubewarden.admission" denied the request: uuid must be under 10000 in container
Error from server: error when creating "privileged-containers.yml": admission webhook "clusterwide-uid-under-10000-is-forbidden.kubewarden.admission" denied the request: uuid must be under 10000 in container
Error from server: error when creating "readiness-probe-is-not-set.yml": admission webhook "clusterwide-readiness-probes-are-required.kubewarden.admission" denied the request: readiness probes are not configured in container
Error from server: error when creating "run-as-user-1000.yml": admission webhook "clusterwide-uid-under-10000-is-forbidden.kubewarden.admission" denied the request: uuid must be under 10000 in container
Error from server: error when creating "run-as-user-zero.yml": admission webhook "clusterwide-uid-under-10000-is-forbidden.kubewarden.admission" denied the request: uuid must be under 10000 in container
Error from server: error when creating "without-security-context.yml": admission webhook "clusterwide-uid-under-10000-is-forbidden.kubewarden.admission" denied the request: uuid must be under 10000 in container
Error from server: error when creating "writable-root-filesystem.yml": admission webhook "clusterwide-read-only-filesystem-policy.kubewarden.admission" denied the request: One of the containers does not have readOnlyRootFilesystem enabled

Applying secure pods...
-------------------------------
Results
-------------------------------
Successfull: 19/30
Unsuccessfull: 11/30
Safe pods accepted:
secure-pod

Risky pods rejected:
cpu-limits-are-not-set
cpu-requests-are-not-set
dummy-image-registry
empty-tag
image-pull-policy-if-not-present
image-pull-policy-never
image-tag
latest-tag
liveness-probe-is-not-set
memory-limits-are-not-set
memory-requests-are-not-set
priviledge-escalation-missing
privileged-containers
readiness-probe-is-not-set
run-as-user-1000
run-as-user-zero
without-security-context
writable-root-filesystem

Risky pods accepted:
0. Description: Pod without dropped capabilities, but added kill capability ||| Risk Reason: Container process can kill other processes. If KILL capability can be added, there is a risk that other capabilities can be added too. 

1. Description: Pod without dropped capabilities ||| Risk Reason: Compromised container process will have default parts of root permissions (capabilities) 

2. Description: Pod with shared IPC namespace ||| Risk Reason: Container process has access to host interprocess comunication resources and can potentially manipulate with them - eg. communicate with host using shared memory 

3. Description: Pod with mounted docker socket ||| Risk Reason: Attacker can manipulate with Docker on host from container via socket. Attacket can manipulate with images on host, eg. stop them and cause DoS, or break from container via creation of privileged container. 

4. Description: Pod with host mount ||| Risk Reason: Host mount exposes files or directories from host filesystem. Attacker can read, modify or delete this information from container (only read if readOnly). Violates all three attributes of CIA triad (only confidentiality if readOnly). 

5. Description: Pod with shared network namespace ||| Risk Reason: Container process has access to network namespace of host, which can be abused eg. for network traffic snooping 

6. Description: Pod with shared PID namespace ||| Risk Reason: Container process has access to host processes and can potentially manipulate with them. 

7. Description: Pod with allowPrivilegeEscalation field set to true. ||| Risk Reason: Process can obtain higher privileges than parent process 

8. Description: Pod with runAsNonRoot field set to false. ||| Risk Reason: Processes will be run under root user 

9. Description: Pod without runAsNonRoot field. ||| Risk Reason: Processes will be run under root user 

10. Description: Pod without disabled seccomp via Unconfined seccomp type ||| Risk Reason: Seccomp filters configured system calls. Disabling seccomp allows unrestricted access to system calls for container processes. 


Safe pods rejected:
```

### Cluster security check - new namespace, Pod Security Standards - built-in admission controller - privileged profile
- **input**
```
controlplane $ bash apply.sh -n test -p privileged -s ./example-settings.yaml
```

- **output**
```
-------------------------------
Starting cluster security check
-------------------------------
Creating namespace test
Applying security profile - 'privileged' to namespace with enforce-version v1.26

Applying vulnerable pods...

Applying secure pods...
-------------------------------
Results
-------------------------------
Successfull: 1/30
Unsuccessfull: 29/30
Safe pods accepted:
secure-pod

Risky pods rejected:

Risky pods accepted:
0. Description: Pod without dropped capabilities, but added kill capability ||| Risk Reason: Container process can kill other processes. If KILL capability can be added, there is a risk that other capabilities can be added too. 

1. Description: Container without set CPU limits ||| Risk Reason: Container can consume all of host CPU cores, and cause resource starvation for other pods. 

2. Description: Container without set CPU requests ||| Risk Reason: If CPU requests are not set, other misbehaving pod can cause resource starvation for this pod. 

3. Description: Pod without dropped capabilities ||| Risk Reason: Compromised container process will have default parts of root permissions (capabilities) 

4. Description: Container with dummy image registry ||| Risk Reason: Image registry is unrestricted, higher risk of malicious images. Pull images only from registries you can trust. 

5. Description: Container with empty tag ||| Risk Reason: Pod can run new version of image on restarts. The version can be malicious or with breaking changes. Same as usage of latest tag. 

6. Description: Container has imagePullPolicy set to IfNotPresent ||| Risk Reason: Attacker can poison local registry, thus malicious image will be loaded. 

7. Description: Container has imagePullPolicy set to Never ||| Risk Reason: Attacker can poison local registry, thus malicious image will be loaded. 

8. Description: Container with image referenced by tag ||| Risk Reason: Attacker can poison local registry, thus malicious image will be loaded. Instead, reference image by digest. 

9. Description: Pod with shared IPC namespace ||| Risk Reason: Container process has access to host interprocess comunication resources and can potentially manipulate with them - eg. communicate with host using shared memory 

10. Description: Container with latest tag ||| Risk Reason: Pod can run new version of image on restarts. The version can be malicious or with breaking changes. 

11. Description: Container has not set liveness probe ||| Risk Reason: Without correct liveness probe, container can be in ill-state and not be restarted. 

12. Description: Container without set memory limits ||| Risk Reason: Container can consume all of host memory, and cause resource starvation for other pods. 

13. Description: Container without set memory requests ||| Risk Reason: If memory requests are not set, other misbehaving container can cause resource starvation for this pod. 

14. Description: Pod with mounted docker socket ||| Risk Reason: Attacker can manipulate with Docker on host from container via socket. Attacket can manipulate with images on host, eg. stop them and cause DoS, or break from container via creation of privileged container. 

15. Description: Pod with host mount ||| Risk Reason: Host mount exposes files or directories from host filesystem. Attacker can read, modify or delete this information from container (only read if readOnly). Violates all three attributes of CIA triad (only confidentiality if readOnly). 

16. Description: Pod with shared network namespace ||| Risk Reason: Container process has access to network namespace of host, which can be abused eg. for network traffic snooping 

17. Description: Pod with shared PID namespace ||| Risk Reason: Container process has access to host processes and can potentially manipulate with them. 

18. Description: Pod without allowPrivilegeEscalation field. ||| Risk Reason: Process can obtain higher privileges than parent process 

19. Description: Pod with allowPrivilegeEscalation field set to true. ||| Risk Reason: Process can obtain higher privileges than parent process 

20. Description: Pod with privileged field set to true. ||| Risk Reason: Containers run without any isolation from host. 

21. Description: Container has not set readiness probe ||| Risk Reason: Without readiness probe, traffic will be sent to pod that is just inicializing, causing undesirable behaviour. 

22. Description: Pod with runAsNonRoot field set to false. ||| Risk Reason: Processes will be run under root user 

23. Description: Pod without runAsNonRoot field. ||| Risk Reason: Processes will be run under root user 

24. Description: Pod with runAsUser field set to 1000. ||| Risk Reason: UID of container user can clash with user on host machine, and reference priviledged user. 

25. Description: Pod with runAsUser field set to zero. ||| Risk Reason: Processes will be run under root user 

26. Description: Pod without disabled seccomp via Unconfined seccomp type ||| Risk Reason: Seccomp filters configured system calls. Disabling seccomp allows unrestricted access to system calls for container processes. 

27. Description: Pod without any security context or security settings. ||| Risk Reason: It is possible to deploy pod to your cluster without any security settings or security settings 

28. Description: Pod with readOnlyRootFilesystem set to false ||| Risk Reason: Container process can manipulate with filesystem, modify and delete important files, eg. configuration 


Safe pods rejected:
```

### Cluster security check - new namespace, Pod Security Standards - built-in admission controller - baseline profile
- **input**
```
controlplane $ bash apply.sh -n test -p baseline -s ./example-settings.yaml
```

- **output**
```
-------------------------------
Starting cluster security check
-------------------------------
Creating namespace test
Applying security profile - 'baseline' to namespace with enforce-version v1.26

Applying vulnerable pods...
Error from server (Forbidden): error when creating "ipc-namespace-sharing.yml": pods "ipc-namespace-sharing" is forbidden: violates PodSecurity "baseline:v1.26": host namespaces (hostIPC=true)
Error from server (Forbidden): error when creating "mount-docker-socket.yml": pods "mount-docker-socket" is forbidden: violates PodSecurity "baseline:v1.26": hostPath volumes (volume "hostpath-volume")
Error from server (Forbidden): error when creating "mount-host-path.yml": pods "mount-host-path" is forbidden: violates PodSecurity "baseline:v1.26": hostPath volumes (volume "hostpath-volume")
Error from server (Forbidden): error when creating "network-namespace-sharing.yml": pods "network-namespace-sharing" is forbidden: violates PodSecurity "baseline:v1.26": host namespaces (hostNetwork=true)
Error from server (Forbidden): error when creating "pid-namespace-sharing.yml": pods "pid-namespace-sharing" is forbidden: violates PodSecurity "baseline:v1.26": host namespaces (hostPID=true)
Error from server (Forbidden): error when creating "privileged-containers.yml": pods "privileged-containers" is forbidden: violates PodSecurity "baseline:v1.26": privileged (container "privileged-containers-container" must not set securityContext.privileged=true)
Error from server (Forbidden): error when creating "unconfined-seccomp-type.yml": pods "unconfined-seccomp-type" is forbidden: violates PodSecurity "baseline:v1.26": seccompProfile (container "unconfined-seccomp-type" must not set securityContext.seccompProfile.type to "Unconfined")

Applying secure pods...
-------------------------------
Results
-------------------------------
Successfull: 8/30
Unsuccessfull: 22/30
Safe pods accepted:
secure-pod

Risky pods rejected:
ipc-namespace-sharing
mount-docker-socket
mount-host-path
network-namespace-sharing
pid-namespace-sharing
privileged-containers
unconfined-seccomp-type

Risky pods accepted:
0. Description: Pod without dropped capabilities, but added kill capability ||| Risk Reason: Container process can kill other processes. If KILL capability can be added, there is a risk that other capabilities can be added too. 

1. Description: Container without set CPU limits ||| Risk Reason: Container can consume all of host CPU cores, and cause resource starvation for other pods. 

2. Description: Container without set CPU requests ||| Risk Reason: If CPU requests are not set, other misbehaving pod can cause resource starvation for this pod. 

3. Description: Pod without dropped capabilities ||| Risk Reason: Compromised container process will have default parts of root permissions (capabilities) 

4. Description: Container with dummy image registry ||| Risk Reason: Image registry is unrestricted, higher risk of malicious images. Pull images only from registries you can trust. 

5. Description: Container with empty tag ||| Risk Reason: Pod can run new version of image on restarts. The version can be malicious or with breaking changes. Same as usage of latest tag. 

6. Description: Container has imagePullPolicy set to IfNotPresent ||| Risk Reason: Attacker can poison local registry, thus malicious image will be loaded. 

7. Description: Container has imagePullPolicy set to Never ||| Risk Reason: Attacker can poison local registry, thus malicious image will be loaded. 

8. Description: Container with image referenced by tag ||| Risk Reason: Attacker can poison local registry, thus malicious image will be loaded. Instead, reference image by digest. 

9. Description: Container with latest tag ||| Risk Reason: Pod can run new version of image on restarts. The version can be malicious or with breaking changes. 

10. Description: Container has not set liveness probe ||| Risk Reason: Without correct liveness probe, container can be in ill-state and not be restarted. 

11. Description: Container without set memory limits ||| Risk Reason: Container can consume all of host memory, and cause resource starvation for other pods. 

12. Description: Container without set memory requests ||| Risk Reason: If memory requests are not set, other misbehaving container can cause resource starvation for this pod. 

13. Description: Pod without allowPrivilegeEscalation field. ||| Risk Reason: Process can obtain higher privileges than parent process 

14. Description: Pod with allowPrivilegeEscalation field set to true. ||| Risk Reason: Process can obtain higher privileges than parent process 

15. Description: Container has not set readiness probe ||| Risk Reason: Without readiness probe, traffic will be sent to pod that is just inicializing, causing undesirable behaviour. 

16. Description: Pod with runAsNonRoot field set to false. ||| Risk Reason: Processes will be run under root user 

17. Description: Pod without runAsNonRoot field. ||| Risk Reason: Processes will be run under root user 

18. Description: Pod with runAsUser field set to 1000. ||| Risk Reason: UID of container user can clash with user on host machine, and reference priviledged user. 

19. Description: Pod with runAsUser field set to zero. ||| Risk Reason: Processes will be run under root user 

20. Description: Pod without any security context or security settings. ||| Risk Reason: It is possible to deploy pod to your cluster without any security settings or security settings 

21. Description: Pod with readOnlyRootFilesystem set to false ||| Risk Reason: Container process can manipulate with filesystem, modify and delete important files, eg. configuration 


Safe pods rejected:
```

### Cluster security check - new namespace, Pod Security Standards - built-in admission controller - restricted profile
- **input**
```
controlplane $ bash apply.sh -n test -p restricted -s ./example-settings.yaml
```

- **output**
```
-------------------------------
Starting cluster security check
-------------------------------
Creating namespace test
Applying security profile - 'restricted' to namespace with enforce-version v1.26

Applying vulnerable pods...
Error from server (Forbidden): error when creating "add-kill-capability.yml": pods "add-kill-capability" is forbidden: violates PodSecurity "restricted:v1.26": unrestricted capabilities (container "add-kill-capability-container" must not include "KILL" in securityContext.capabilities.add)
No resources found in test namespace.
Error from server (Forbidden): error when creating "drop-capabilities.yml": pods "drop-capabilities" is forbidden: violates PodSecurity "restricted:v1.26": unrestricted capabilities (container "drop-capabilities-container" must set securityContext.capabilities.drop=["ALL"])
Error from server (Forbidden): error when creating "ipc-namespace-sharing.yml": pods "ipc-namespace-sharing" is forbidden: violates PodSecurity "restricted:v1.26": host namespaces (hostIPC=true)
Error from server (Forbidden): error when creating "mount-docker-socket.yml": pods "mount-docker-socket" is forbidden: violates PodSecurity "restricted:v1.26": unrestricted capabilities (container "mount-docker-socket-container" must not include "KILL" in securityContext.capabilities.add), restricted volume types (volume "hostpath-volume" uses restricted volume type "hostPath")
Error from server (Forbidden): error when creating "mount-host-path.yml": pods "mount-host-path" is forbidden: violates PodSecurity "restricted:v1.26": restricted volume types (volume "hostpath-volume" uses restricted volume type "hostPath")
Error from server (Forbidden): error when creating "network-namespace-sharing.yml": pods "network-namespace-sharing" is forbidden: violates PodSecurity "restricted:v1.26": host namespaces (hostNetwork=true)
Error from server (Forbidden): error when creating "pid-namespace-sharing.yml": pods "pid-namespace-sharing" is forbidden: violates PodSecurity "restricted:v1.26": host namespaces (hostPID=true)
Error from server (Forbidden): error when creating "priviledge-escalation-missing.yml": pods "priviledge-escalation-missing" is forbidden: violates PodSecurity "restricted:v1.26": allowPrivilegeEscalation != false (container "priviledge-escalation-missing-container" must set securityContext.allowPrivilegeEscalation=false)
Error from server (Forbidden): error when creating "priviledge-escalation-true.yml": pods "priviledge-escalation-true" is forbidden: violates PodSecurity "restricted:v1.26": allowPrivilegeEscalation != false (container "priviledge-escalation-true-container" must set securityContext.allowPrivilegeEscalation=false)
Error from server (Forbidden): error when creating "privileged-containers.yml": pods "privileged-containers" is forbidden: violates PodSecurity "restricted:v1.26": privileged (container "privileged-containers-container" must not set securityContext.privileged=true), allowPrivilegeEscalation != false (container "privileged-containers-container" must set securityContext.allowPrivilegeEscalation=false)
Error from server (Forbidden): error when creating "run-as-nonroot-false.yml": pods "run-as-nonroot-false" is forbidden: violates PodSecurity "restricted:v1.26": runAsNonRoot != true (container "run-as-nonroot-false-container" must not set securityContext.runAsNonRoot=false)
Error from server (Forbidden): error when creating "run-as-nonroot-missing.yml": pods "run-as-nonroot-missing" is forbidden: violates PodSecurity "restricted:v1.26": runAsNonRoot != true (pod or container "run-as-nonroot-missing-container" must set securityContext.runAsNonRoot=true)
Error from server (Forbidden): error when creating "run-as-user-zero.yml": pods "run-as-user-zero" is forbidden: violates PodSecurity "restricted:v1.26": runAsUser=0 (container "run-as-user-zero-container" must not set runAsUser=0)
Error from server (Forbidden): error when creating "unconfined-seccomp-type.yml": pods "unconfined-seccomp-type" is forbidden: violates PodSecurity "restricted:v1.26": seccompProfile (container "unconfined-seccomp-type" must not set securityContext.seccompProfile.type to "Unconfined")
Error from server (Forbidden): error when creating "without-security-context.yml": pods "without-security-context" is forbidden: violates PodSecurity "restricted:v1.26": allowPrivilegeEscalation != false (container "without-security-context-container" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "without-security-context-container" must set securityContext.capabilities.drop=["ALL"]), runAsNonRoot != true (pod or container "without-security-context-container" must set securityContext.runAsNonRoot=true), seccompProfile (pod or container "without-security-context-container" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")

Applying secure pods...
-------------------------------
Results
-------------------------------
Successfull: 16/30
Unsuccessfull: 14/30
Safe pods accepted:
secure-pod

Risky pods rejected:
add-kill-capability
drop-capabilities
ipc-namespace-sharing
mount-docker-socket
mount-host-path
network-namespace-sharing
pid-namespace-sharing
priviledge-escalation-missing
priviledge-escalation-true
privileged-containers
run-as-nonroot-false
run-as-nonroot-missing
run-as-user-zero
unconfined-seccomp-type
without-security-context

Risky pods accepted:
0. Description: Container without set CPU limits ||| Risk Reason: Container can consume all of host CPU cores, and cause resource starvation for other pods. 

1. Description: Container without set CPU requests ||| Risk Reason: If CPU requests are not set, other misbehaving pod can cause resource starvation for this pod. 

2. Description: Container with dummy image registry ||| Risk Reason: Image registry is unrestricted, higher risk of malicious images. Pull images only from registries you can trust. 

3. Description: Container with empty tag ||| Risk Reason: Pod can run new version of image on restarts. The version can be malicious or with breaking changes. Same as usage of latest tag. 

4. Description: Container has imagePullPolicy set to IfNotPresent ||| Risk Reason: Attacker can poison local registry, thus malicious image will be loaded. 

5. Description: Container has imagePullPolicy set to Never ||| Risk Reason: Attacker can poison local registry, thus malicious image will be loaded. 

6. Description: Container with image referenced by tag ||| Risk Reason: Attacker can poison local registry, thus malicious image will be loaded. Instead, reference image by digest. 

7. Description: Container with latest tag ||| Risk Reason: Pod can run new version of image on restarts. The version can be malicious or with breaking changes. 

8. Description: Container has not set liveness probe ||| Risk Reason: Without correct liveness probe, container can be in ill-state and not be restarted. 

9. Description: Container without set memory limits ||| Risk Reason: Container can consume all of host memory, and cause resource starvation for other pods. 

10. Description: Container without set memory requests ||| Risk Reason: If memory requests are not set, other misbehaving container can cause resource starvation for this pod. 

11. Description: Container has not set readiness probe ||| Risk Reason: Without readiness probe, traffic will be sent to pod that is just inicializing, causing undesirable behaviour. 

12. Description: Pod with runAsUser field set to 1000. ||| Risk Reason: UID of container user can clash with user on host machine, and reference priviledged user. 

13. Description: Pod with readOnlyRootFilesystem set to false ||| Risk Reason: Container process can manipulate with filesystem, modify and delete important files, eg. configuration 


Safe pods rejected:
```
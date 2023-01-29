# Tool Specification
- document specifies expected behaviour of the tool with `apply.sh` as entrypoint
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

## "Good case" scenarios

### Cluster security check - new namespace, without installed policies
- **input**
```
controlplane $ bash apply.sh -n test
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
Successfull: 1/2
Unsuccessfull: 1/2
Successfully accepted:
secure-pod

Successfully rejected:

Wrongly accepted:
without-security-context
```

### Cluster security check - new namespace, Kyverno as policy enforcement
- **input**
```
controlplane $ bash apply.sh -n test -e kyverno
```

- **output**
```
-------------------------------
Starting cluster security check
-------------------------------
Creating namespace test
Installing Kyverno 1.7 in Standalone mode
For production installation, use 'helm' package manager for Kubernetes, specify exact version, and set at least 3 replicas.
Installing Kyverno...
Waiting for policies to be ready

Applying vulnerable pods...
Error from server: error when creating "without-security-context.yml": admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Pod/test/without-security-context was blocked due to the following policies

require-ro-rootfs:
  validate-readOnlyRootFilesystem: 'validation error: Root filesystem must be read-only.
    Rule validate-readOnlyRootFilesystem failed at path /spec/containers/0/securityContext/'
No resources found in test namespace.

Applying secure pods...
-------------------------------
Results
-------------------------------
Successfull: 2/2
Unsuccessfull: 0/2
Successfully accepted:
secure-pod

Successfully rejected:
without-security-context

Wrongly accepted:

Wrongly rejected:
```

### Cluster security check - new namespace, Gatekeeper as policy enforcement
- **input**
```
controlplane $ bash apply.sh -n test -e gatekeeper
```

- **output**
```
-------------------------------
Starting cluster security check
-------------------------------
Creating namespace test
Installing gatekeeper...
Waiting for policies to be ready

Applying vulnerable pods...
Error from server (Forbidden): error when creating "without-security-context.yml": admission webhook "validation.gatekeeper.sh" denied the request: [psp-readonlyrootfilesystem] only read-only root filesystem container is allowed: without-security-context
No resources found in test namespace.

Applying secure pods...
-------------------------------
Results
-------------------------------
Successfull: 2/2
Unsuccessfull: 0/2
Successfully accepted:
secure-pod

Successfully rejected:
without-security-context

Wrongly accepted:

Wrongly rejected:
```

### Cluster security check - new namespace, Kubewarden as policy enforcement
- TODO: kubewarden does not have any policies - 'without-security-context' was successfully applied
- **input**
```
controlplane $ bash apply.sh -n test -e kubewarden
```

- **output**
```
-------------------------------
Starting cluster security check
-------------------------------
Creating namespace test
Installing kubewarden (crds - 1.2.3, controller 1.4.0, defaults 1.5.1)...
Waiting for cert manager...
Waiting for crds...
Waiting for controller...
Waiting for defaults...
Waiting for policies to be ready

Applying vulnerable pods...
Error from server: error when creating "without-security-context.yml": admission webhook "clusterwide-read-only-filesystem-policy.kubewarden.admission" denied the request: One of the containers does not have readOnlyRootFilesystem enabled
No resources found in test namespace.

Applying secure pods...
-------------------------------
Results
-------------------------------
Successfull: 2/2
Unsuccessfull: 0/2
Successfully accepted:
secure-pod

Successfully rejected:
without-security-context

Wrongly accepted:

Wrongly rejected:
```
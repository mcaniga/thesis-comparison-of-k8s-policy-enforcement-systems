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
- TODO: will be edited as "kubewarden" will be added
```
-------------------------------
Starting cluster security check
-------------------------------
Using existing namespace: 'test'
Unknown enforcement library (-e). Known libraries - "kyverno", "gatekeeper"
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
- TODO: 'without-security-context' should be in 'Successfully rejected'
```
Creating namespace test
Installing Kyverno 1.7 in Standalone mode
For production installation, use 'helm' package manager for Kubernetes, specify exact version, and set at least 3 replicas.
namespace/kyverno created
customresourcedefinition.apiextensions.k8s.io/clusterpolicies.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/clusterpolicyreports.wgpolicyk8s.io created
customresourcedefinition.apiextensions.k8s.io/clusterreportchangerequests.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/generaterequests.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/policies.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/policyreports.wgpolicyk8s.io created
customresourcedefinition.apiextensions.k8s.io/reportchangerequests.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/updaterequests.kyverno.io created
serviceaccount/kyverno-service-account created
role.rbac.authorization.k8s.io/kyverno:leaderelection created
clusterrole.rbac.authorization.k8s.io/kyverno:admin-generaterequest created
clusterrole.rbac.authorization.k8s.io/kyverno:admin-policies created
clusterrole.rbac.authorization.k8s.io/kyverno:admin-policyreport created
clusterrole.rbac.authorization.k8s.io/kyverno:admin-reportchangerequest created
clusterrole.rbac.authorization.k8s.io/kyverno:events created
clusterrole.rbac.authorization.k8s.io/kyverno:generate created
clusterrole.rbac.authorization.k8s.io/kyverno:policies created
clusterrole.rbac.authorization.k8s.io/kyverno:userinfo created
clusterrole.rbac.authorization.k8s.io/kyverno:view created
clusterrole.rbac.authorization.k8s.io/kyverno:webhook created
rolebinding.rbac.authorization.k8s.io/kyverno:leaderelection created
clusterrolebinding.rbac.authorization.k8s.io/kyverno:events created
clusterrolebinding.rbac.authorization.k8s.io/kyverno:generate created
clusterrolebinding.rbac.authorization.k8s.io/kyverno:policies created
clusterrolebinding.rbac.authorization.k8s.io/kyverno:userinfo created
clusterrolebinding.rbac.authorization.k8s.io/kyverno:view created
clusterrolebinding.rbac.authorization.k8s.io/kyverno:webhook created
configmap/kyverno created
configmap/kyverno-metrics created
service/kyverno-svc created
service/kyverno-svc-metrics created
deployment.apps/kyverno created
Installing Kyverno...
Waiting for policies to be ready

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

Wrongly rejected:
```

### Cluster security check - new namespace, Gatekeeper as policy enforcement
- **input**
```
controlplane $ bash apply.sh -n test -e gatekeeper
```

- **output**
- TODO: 'without-security-context' should be in 'Successfully rejected' - can be linked with error in logs
```
-------------------------------
Starting cluster security check
-------------------------------
Creating namespace test
Installing Kyverno 1.7 in Standalone mode
For production installation, use 'helm' package manager for Kubernetes, specify exact version, and set at least 3 replicas.
namespace/kyverno created
customresourcedefinition.apiextensions.k8s.io/clusterpolicies.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/clusterpolicyreports.wgpolicyk8s.io created
customresourcedefinition.apiextensions.k8s.io/clusterreportchangerequests.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/generaterequests.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/policies.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/policyreports.wgpolicyk8s.io created
customresourcedefinition.apiextensions.k8s.io/reportchangerequests.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/updaterequests.kyverno.io created
serviceaccount/kyverno-service-account created
role.rbac.authorization.k8s.io/kyverno:leaderelection created
clusterrole.rbac.authorization.k8s.io/kyverno:admin-generaterequest created
clusterrole.rbac.authorization.k8s.io/kyverno:admin-policies created
clusterrole.rbac.authorization.k8s.io/kyverno:admin-policyreport created
clusterrole.rbac.authorization.k8s.io/kyverno:admin-reportchangerequest created
clusterrole.rbac.authorization.k8s.io/kyverno:events created
clusterrole.rbac.authorization.k8s.io/kyverno:generate created
clusterrole.rbac.authorization.k8s.io/kyverno:policies created
clusterrole.rbac.authorization.k8s.io/kyverno:userinfo created
clusterrole.rbac.authorization.k8s.io/kyverno:view created
clusterrole.rbac.authorization.k8s.io/kyverno:webhook created
rolebinding.rbac.authorization.k8s.io/kyverno:leaderelection created
clusterrolebinding.rbac.authorization.k8s.io/kyverno:events created
clusterrolebinding.rbac.authorization.k8s.io/kyverno:generate created
clusterrolebinding.rbac.authorization.k8s.io/kyverno:policies created
clusterrolebinding.rbac.authorization.k8s.io/kyverno:userinfo created
clusterrolebinding.rbac.authorization.k8s.io/kyverno:view created
clusterrolebinding.rbac.authorization.k8s.io/kyverno:webhook created
configmap/kyverno created
configmap/kyverno-metrics created
service/kyverno-svc created
service/kyverno-svc-metrics created
deployment.apps/kyverno created
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
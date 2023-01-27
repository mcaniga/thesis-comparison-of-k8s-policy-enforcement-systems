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
error: timed out waiting for the condition on pods/kyverno-5cb75df46-zkg67
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
- TODO: 'without-security-context' was accepted, error in logs
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
namespace/gatekeeper-system created
resourcequota/gatekeeper-critical-pods created
customresourcedefinition.apiextensions.k8s.io/assign.mutations.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/assignmetadata.mutations.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/configs.config.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/constraintpodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/constrainttemplatepodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/constrainttemplates.templates.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/expansiontemplate.expansion.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/modifyset.mutations.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/mutatorpodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/providers.externaldata.gatekeeper.sh created
serviceaccount/gatekeeper-admin created
role.rbac.authorization.k8s.io/gatekeeper-manager-role created
clusterrole.rbac.authorization.k8s.io/gatekeeper-manager-role created
rolebinding.rbac.authorization.k8s.io/gatekeeper-manager-rolebinding created
clusterrolebinding.rbac.authorization.k8s.io/gatekeeper-manager-rolebinding created
secret/gatekeeper-webhook-server-cert created
service/gatekeeper-webhook-service created
deployment.apps/gatekeeper-audit created
deployment.apps/gatekeeper-controller-manager created
poddisruptionbudget.policy/gatekeeper-controller-manager created
mutatingwebhookconfiguration.admissionregistration.k8s.io/gatekeeper-mutating-webhook-configuration created
validatingwebhookconfiguration.admissionregistration.k8s.io/gatekeeper-validating-webhook-configuration created
Installing gatekeeper...
error: resource mapping not found for name: "psp-readonlyrootfilesystem" namespace: "" from "./gatekeeper/policies/read-only-filesystem-policy.yml": no matches for kind "K8sPSPReadOnlyRootFilesystem" in version "constraints.gatekeeper.sh/v1beta1"
ensure CRDs are installed first
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
namespace/cert-manager created
customresourcedefinition.apiextensions.k8s.io/clusterissuers.cert-manager.io created
customresourcedefinition.apiextensions.k8s.io/challenges.acme.cert-manager.io created
customresourcedefinition.apiextensions.k8s.io/certificaterequests.cert-manager.io created
customresourcedefinition.apiextensions.k8s.io/issuers.cert-manager.io created
customresourcedefinition.apiextensions.k8s.io/certificates.cert-manager.io created
customresourcedefinition.apiextensions.k8s.io/orders.acme.cert-manager.io created
serviceaccount/cert-manager-cainjector created
serviceaccount/cert-manager created
serviceaccount/cert-manager-webhook created
configmap/cert-manager-webhook created
clusterrole.rbac.authorization.k8s.io/cert-manager-cainjector created
clusterrole.rbac.authorization.k8s.io/cert-manager-controller-issuers created
clusterrole.rbac.authorization.k8s.io/cert-manager-controller-clusterissuers created
clusterrole.rbac.authorization.k8s.io/cert-manager-controller-certificates created
clusterrole.rbac.authorization.k8s.io/cert-manager-controller-orders created
clusterrole.rbac.authorization.k8s.io/cert-manager-controller-challenges created
clusterrole.rbac.authorization.k8s.io/cert-manager-controller-ingress-shim created
clusterrole.rbac.authorization.k8s.io/cert-manager-view created
clusterrole.rbac.authorization.k8s.io/cert-manager-edit created
clusterrole.rbac.authorization.k8s.io/cert-manager-controller-approve:cert-manager-io created
clusterrole.rbac.authorization.k8s.io/cert-manager-controller-certificatesigningrequests created
clusterrole.rbac.authorization.k8s.io/cert-manager-webhook:subjectaccessreviews created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-cainjector created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-controller-issuers created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-controller-clusterissuers created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-controller-certificates created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-controller-orders created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-controller-challenges created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-controller-ingress-shim created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-controller-approve:cert-manager-io created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-controller-certificatesigningrequests created
clusterrolebinding.rbac.authorization.k8s.io/cert-manager-webhook:subjectaccessreviews created
role.rbac.authorization.k8s.io/cert-manager-cainjector:leaderelection created
role.rbac.authorization.k8s.io/cert-manager:leaderelection created
role.rbac.authorization.k8s.io/cert-manager-webhook:dynamic-serving created
rolebinding.rbac.authorization.k8s.io/cert-manager-cainjector:leaderelection created
rolebinding.rbac.authorization.k8s.io/cert-manager:leaderelection created
rolebinding.rbac.authorization.k8s.io/cert-manager-webhook:dynamic-serving created
service/cert-manager created
service/cert-manager-webhook created
deployment.apps/cert-manager-cainjector created
deployment.apps/cert-manager created
deployment.apps/cert-manager-webhook created
mutatingwebhookconfiguration.admissionregistration.k8s.io/cert-manager-webhook created
validatingwebhookconfiguration.admissionregistration.k8s.io/cert-manager-webhook created
deployment.apps/cert-manager condition met
deployment.apps/cert-manager-cainjector condition met
deployment.apps/cert-manager-webhook condition met
"kubewarden" has been added to your repositories
NAME: kubewarden-crds
LAST DEPLOYED: Fri Jan 27 10:05:31 2023
NAMESPACE: kubewarden
STATUS: deployed
REVISION: 1
TEST SUITE: None
NAME: kubewarden-controller
LAST DEPLOYED: Fri Jan 27 10:05:34 2023
NAMESPACE: kubewarden
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
kubewarden-controller installed.

You can start defining admission policies by using the cluster-wide
`clusteradmissionpolicies.policies.kubewarden.io` or the namespaced
`admissionpolicies.policies.kubewarden.io` resources.

For more information check out https://kubewarden.io/
NAME: kubewarden-defaults
LAST DEPLOYED: Fri Jan 27 10:05:48 2023
NAMESPACE: kubewarden
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
kubewarden-defaults installed.

You now have a PolicyServer running in your cluster ready to run any
`clusteradmissionpolicies.policies.kubewarden.io` or
`admissionpolicies.policies.kubewarden.io` resources.

For more information on how to define policies, check out https://kubewarden.io/
error: no objects passed to apply
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
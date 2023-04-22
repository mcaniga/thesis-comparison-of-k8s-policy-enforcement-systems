# Available Parameters

List of possible attributes of `apply.sh` script.

| Param  | Required      | Description | Argument Type |                                           
|--------|---------------|-------------|--------|
| -n     | yes           | Determines in which namespace the test will be executed. If provided namespace does not exist, it will be created - recommended for testing of cluster policies and new namespaces. | String
| -e     | no            | Installs **e**nforcement lib along with policies, to secure the cluster | 'kyverno' or 'gatekeeper' or 'kubewarden'
| -p     | no            | Enforces security **p**rofile from Pod Security Standards - https://kubernetes.io/docs/concepts/security/pod-security-standards/ | 'privileged' or 'baseline' or 'restricted'
| -d     | no            | !!! Use with cauction in existing namespaces!!! **d**eletes the namespace after test, along with created pods and policies. Usefull for new namespaces, may be malicious for existing namespaces. | no argument
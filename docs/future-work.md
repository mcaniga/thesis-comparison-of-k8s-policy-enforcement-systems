# Feature work

This document provides list of not implemented, nice to have features.

## Namespaced policies
Policies are now cluster wide, enforcing policies also in namespaces that must have loosen restrictions  

**Possible solution**
- add id to policies metadata
- omit policies based on parameter ('-o <id>,<id2>' for **o**mit)

## Omit policies
Enable omitting policies by policy ID.  
Ensure that omitting multiple policies is possible.  
**Possible solution**
- add id to policies metadata
- omit policies based on parameter ('-o <id>,<id2>' for **o**mit)

## Omit PSS policies
Pod Security Admission Controller does not allow ommiting of policies.  
Enforce PSS in Kyverno, OPA Gatekeeper and Kubewarden additional to Pod Security Admission Controller  
Leave -p parameter untouched.  
**Possible solution**
- solution 1
    - implement all policies gradually by hand and use -o parameter to omit them
- solution 2
    - use community PSS package for Kyverno, OPA Gatekeeper and Kubewarden with omitting functionality

## Use specified image registry in security test
Security test now uses Docker Hub as image registry for fetching **alpine** image for vulnerable and secure pods.
Not all enviroments will have Docker Hub enabled, organizations can use custom registries in secure enviroments.

**Possible solution**
- parametrize register in image field in pod manifest
- Helm can be used for pod manifest parametrization

## Support multiple Kubernetes versions
Now only Kubernetes 1.26 is supported.  
Test and document support for other versions.
**Possible solution**
- try all features with different Kubernetes versions, eg. 1.25
    - security test
    - installation of policy libs
    - enforcing PSS with Pod Security Admission Controller   
- document supported versions in README.md
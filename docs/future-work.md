# Feature work

This document provides list of not implemented, nice to have features.

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

## Support multiple Kubernetes versions
Now only Kubernetes 1.26, 1.27, 1.28 is supported.  
Test and document support for other versions.
**Possible solution**
- try all features with different Kubernetes versions, eg. 1.25
    - security test
    - installation of policy libs
    - enforcing PSS with Pod Security Admission Controller   
- document supported versions in README.md

# Implementation

This document provides implementation details of the solution.

## Flow
1. Params parsing
    - parameters are specified in `docs/params.md`
2. Params validation
    - checking if namespace is provided
3. Instalation of enforcement library (optional)
    - skipped if no enforcement library was specified by parameters
4. Application of security profile (optional)
    - skipped if no profile was specified by parameters
5. Application of vulnerable pods into namespace
6. Application of secure pods into namespace
7. Final Report

## Application of vulnerable pods into namespace
- pods defined in `/pods/vulnerable` are considered insecure and should not pass the policy checks
- NOTE: **pod convention** - pod filename must match its `metadata.name` to correctly indentify if pod was applied to cluster

## Application of secure pods into namespace
- pods defined in `/pods/secure` are considered secure and must pass the policy checks
- secure pods contain configuration that matches best practices given by restricted profile from PSS and implemented policies
- secure pods are mechanism to ensure that namespace is not simply rejecting all pods, and thus wrongly pass the security check
- NOTE: **pod convention** - pod filename must match its `metadata.name` to correctly indentify if pod was applied to cluster


## Final Report

Metrics listed in final report.
- Number of successful test scenarios
- Total number of unsuccessful test scenarios
- List of successfully accepted pods
- List of successfully rejected pods
- List of wrongly accepted pods, along with reason of their vulnerability 
- List of wrongly rejected pods
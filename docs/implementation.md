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

## Final Report

Metrics listed in final report.
- Number of successful test scenarios
- Total number of unsuccessful test scenarios
- List of successfully accepted pods
- List of successfully rejected pods
- List of wrongly accepted pods
- List of wrongly rejected pods
# Pods

This document provides list of vulnerable pods used in security check, along with their readable name and vulnerability reason.

| Pod name                      | Pod readable name                                           | Vulnerability reason                                                                                                                                                                                                                      |
|-------------------------------|-------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| add-kill-capability           | Pod without dropped capabilities, but added kill capability | Container process can kill other processes.                                                                                                                                                                                               |
| drop-capabilities             | Pod without dropped capabilities                            | TODO                                                                                                                                                                                                                                      |
| mount-docker-socket           | Pod with mounted docker socket                              | Attacker can manipulate with Docker on host from container via socket. Attacket can manipulate with images on host, eg. stop them and cause DoS, or break from container via creation of privileged container.                            |
| mount-host-path               | Pod with host mount                                         | Host mount exposes files or directories from host filesystem. Attacker can read, modify or delete this information from container (only read if readOnly). Violates all three attributes of CIA triad (only confidentiality if readOnly). |
| priviledge-escalation-missing | Pod without allowPrivilegeEscalation field.                 | Process can obtain higher privileges than parent process                                                                                                                                                                                  |
| priviledge-escalation-true    | Pod with allowPrivilegeEscalation field set to true.        | Process can obtain higher privileges than parent process                                                                                                                                                                                  |
| privileged-containers         | Pod with privileged field set to true.                      | Containers run without any isolation from host.                                                                                                                                                                                           |
| run-as-nonroot-false          | Pod with runAsNonRoot field set to false.                   | Processes will be run under root user                                                                                                                                                                                                     |
| run-as-nonroot-missing        | Pod without runAsNonRoot field.                             | Processes will be run under root user                                                                                                                                                                                                     |
| run-as-user-zero              | Pod with runAsUser field set to zero.                       | Processes will be run under root user                                                                                                                                                                                                     |
| without-security-context      | Pod without any security context.                           | It is possible to deploy pod to your cluster without any security settings                                                                                                                                                                |
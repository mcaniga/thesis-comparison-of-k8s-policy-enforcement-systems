package uidUnder10000IsForbidden

violation[{"msg": msg, "details": {}}] {
    container := input.review.object.spec.containers[_]
    run_as_user := container.securityContext.runAsUser
    not run_as_user
    run_as_user < 10000
    msg := sprintf("uuid must be under 10000 in container <%v>", [container.name])
}
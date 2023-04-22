package uidUnder10000IsForbidden

violation[{"msg": msg, "details": {}}] {
    container := input.review.object.spec.containers[_]
    not container.securityContext["runAsUser"]
    msg := sprintf("uuid must be under 10000 in container <%v>", [container.name])
}

violation[{"msg": msg, "details": {}}] {
    container := input.review.object.spec.containers[_]
    container.securityContext.runAsUser < 10000
    msg := sprintf("uuid must be under 10000 in container <%v>", [container.name])
}
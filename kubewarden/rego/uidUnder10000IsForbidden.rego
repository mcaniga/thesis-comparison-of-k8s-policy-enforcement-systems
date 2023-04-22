package uidUnder10000IsForbidden

violation[{"msg": msg}] {
    container := input.review.object.spec.containers[_]
    not container.securityContext["runAsUser"]
    msg := "uuid must be under 10000 in container"
}

violation[{"msg": msg}] {
    container := input.review.object.spec.containers[_]
    container.securityContext.runAsUser < 10000
    msg := "uuid must be under 10000 in container"
}
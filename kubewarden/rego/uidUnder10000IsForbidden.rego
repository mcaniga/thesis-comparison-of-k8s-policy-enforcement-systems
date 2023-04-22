package uidUnder10000IsForbidden

violation {
    container := input.review.object.spec.containers[_]
    not container.securityContext["runAsUser"]
}

violation {
    container := input.review.object.spec.containers[_]
    container.securityContext.runAsUser < 10000
}
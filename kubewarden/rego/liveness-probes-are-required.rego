package liveness-probes-are-required

violation[{"msg": msg, "details": {}}] {
    container := input.review.object.spec.containers[_]
    livenessProbe := container.livenessProbe
    not livenessProbe
}
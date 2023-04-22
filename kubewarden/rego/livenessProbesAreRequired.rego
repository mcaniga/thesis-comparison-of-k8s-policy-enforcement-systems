package livenessProbesAreRequired

violation[{"msg": msg}] {
    container := input.review.object.spec.containers[_]
    not container["livenessProbe"]
    msg := "liveness probes are not configured in container"
}
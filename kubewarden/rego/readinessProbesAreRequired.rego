package readinessProbesAreRequired

violation[{"msg": msg}] {
    container := input.review.object.spec.containers[_]
    not container["readinessProbe"]
    msg := "readiness probes are not configured in container"
}
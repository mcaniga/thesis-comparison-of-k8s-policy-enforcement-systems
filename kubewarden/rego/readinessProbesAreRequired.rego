package readinessProbesAreRequired

violation[{"msg": msg, "details": {}}] {
    container := input.review.object.spec.containers[_]
    readinessProbe := container.readinessProbe
    not readinessProbe
    msg := sprintf("readiness probes are not configured in container <%v>", [container.name])
}
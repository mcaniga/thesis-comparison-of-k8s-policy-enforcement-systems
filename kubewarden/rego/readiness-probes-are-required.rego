package readinessProbesAreRequired

violation[{"msg": msg, "details": {}}] {
    container := input.review.object.spec.containers[_]
    readinessProbe := container.readinessProbe
    not readinessProbe
}
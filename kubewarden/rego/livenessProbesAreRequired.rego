package livenessProbesAreRequired

violation[{"msg": msg, "details": {}}] {
    container := input.review.object.spec.containers[_]
    not container["livenessProbe"]
    msg := sprintf("liveness probes are not configured in container <%v>", [container.name])
}
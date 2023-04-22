package readinessProbesAreRequired

violation {
    container := input.review.object.spec.containers[_]
    not container["readinessProbe"]
}
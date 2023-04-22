package livenessProbesAreRequired

violation {
    container := input.review.object.spec.containers[_]
    not container["livenessProbe"]
}
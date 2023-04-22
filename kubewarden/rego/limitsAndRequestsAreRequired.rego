package limitsAndRequestsAreRequired

violation {
    container := input.review.object.spec.containers[_]
    not container.resources.requests["memory"]
}

violation {
    container := input.review.object.spec.containers[_]
    not container.resources.requests["cpu"]
}

violation {
    container := input.review.object.spec.containers[_]
    not container.resources.limits["memory"]
}

violation {
    container := input.review.object.spec.containers[_]
    not container.resources.limits["cpu"]
}
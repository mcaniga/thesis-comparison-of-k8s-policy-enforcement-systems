package limitsAndRequestsAreRequired

violation[{"msg": msg}] {
    container := input.review.object.spec.containers[_]
    not container.resources.requests["memory"]
    msg := "container has not specified memory requests"
}

violation[{"msg": msg}] {
    container := input.review.object.spec.containers[_]
    not container.resources.requests["cpu"]
    msg := "container has not specified cpu requests"
}

violation[{"msg": msg}] {
    container := input.review.object.spec.containers[_]
    not container.resources.limits["memory"]
    msg := "container has not specified memory limits"
}

violation[{"msg": msg}] {
    container := input.review.object.spec.containers[_]
    not container.resources.limits["cpu"]
    msg := "container has not specified cpu limits"
}
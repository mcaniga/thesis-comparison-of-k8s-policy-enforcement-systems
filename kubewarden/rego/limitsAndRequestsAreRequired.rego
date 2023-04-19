package limitsAndRequestsAreRequired

violation[{"msg": msg, "details": {}}] {
    container := input.review.object.spec.containers[_]
    not container.resources.requests["memory"]
    msg := sprintf("container <%v> has not specified memory requests", [container.name])
}

violation[{"msg": msg, "details": {}}] {
    container := input.review.object.spec.containers[_]
    not container.resources.requests["cpu"]
    msg := sprintf("container <%v> has not specified cpu requests", [container.name])
}

violation[{"msg": msg, "details": {}}] {
    container := input.review.object.spec.containers[_]
    not container.resources.limits["memory"]
    msg := sprintf("container <%v> has not specified memory limits", [container.name])
}

violation[{"msg": msg, "details": {}}] {
    container := input.review.object.spec.containers[_]
    not container.resources.limits["cpu"]
    msg := sprintf("container <%v> has not specified cpu limits", [container.name])
}
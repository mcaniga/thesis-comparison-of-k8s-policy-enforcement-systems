package limitsAndRequestsAreRequired

violation[{"msg": msg, "details": {}}] {
    container := input.review.object.spec.containers[_]
    memory_limit := container.resources.limits.memory
    memory_request := container.resources.requests.memory
    cpu_limit := container.resources.limits.cpu
    cpu_request := container.resources.requests.cpu
    not memory_limit
    not memory_request
    not cpu_limit
    not cpu_request
}
package imageCanBeReferencedOnlyWithImageDigest

violation[{"msg": msg, "details": {}}] {
    c := input_containers[_]
    root_filesystem_is_read_only_violation(c)
    msg := sprintf("only read-only root filesystem container is allowed: %v", [c.name])
}

root_filesystem_is_read_only_violation(c) {
    not has_field(c, "securityContext") or c.securityContext.readOnlyRootFilesystem == false
}

input_containers[c] {
    c := input.review.object.spec.containers[_]
}

# has_field returns whether an object has a field
has_field(object, field) = true {
    object[field]
}
package imageCanBeReferencedOnlyWithImageDigest

violation[{"msg": msg, "details": {}}] {
    container := input.review.object.spec.containers[_]
    not container.securityContext
    container.securityContext.readOnlyRootFilesystem == false
}
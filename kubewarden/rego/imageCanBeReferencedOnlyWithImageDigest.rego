package imageCanBeReferencedOnlyWithImageDigest

violation[{"msg": msg, "details": {}}] {
    container := input.review.object.spec.containers[_]
    satisfied := [re_match("@[a-z0-9]+([+._-][a-z0-9]+)*:[a-zA-Z0-9=_-]+", container.image)]
    not all(satisfied)
    msg := sprintf("container  <%v> must reference image by digest", [container.name])
}
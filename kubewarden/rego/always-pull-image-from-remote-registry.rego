package always-pull-image-from-remote-registry

violation[{"msg": msg}] {
  container := input.review.object.spec.containers[_]
  satisfied := [re_match("@[a-z0-9]+([+._-][a-z0-9]+)*:[a-zA-Z0-9=_-]+", container.image)]
  not all(satisfied)
  msg := sprintf("container <%v> uses an image without a digest <%v>", [container.name, container.image])
}
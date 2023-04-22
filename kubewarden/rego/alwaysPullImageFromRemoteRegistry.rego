package alwaysPullImageFromRemoteRegistry

violation[{"msg": msg}] {
    container := input.review.object.spec.containers[_]
    not container["imagePullPolicy"]
    msg := "imagePullPolicy should be always"
}

violation[{"msg": msg}] {
  container := input.review.object.spec.containers[_]
  container.imagePullPolicy != "Always"
  msg := "imagePullPolicy should be always"
}
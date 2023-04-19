package alwaysPullImageFromRemoteRegistry

violation[{"msg": msg, "details": {}}] {
    container := input.review.object.spec.containers[_]
    not container.imagePullPolicy["imagePullPolicy"]
    msg := sprintf("container <%v> has not set imagePullPolicy to Always", [container.name])
}

violation[{"msg": msg}] {
  container := input.review.object.spec.containers[_]
  container.imagePullPolicy != "Always"
  msg := sprintf("container <%v> has not set imagePullPolicy to Always", [container.name])
}
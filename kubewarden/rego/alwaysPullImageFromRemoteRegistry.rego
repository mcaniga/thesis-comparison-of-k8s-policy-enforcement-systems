package alwaysPullImageFromRemoteRegistry

violation {
    container := input.review.object.spec.containers[_]
    not container["imagePullPolicy"]
}

violation {
  container := input.review.object.spec.containers[_]
  container.imagePullPolicy != "Always"
}
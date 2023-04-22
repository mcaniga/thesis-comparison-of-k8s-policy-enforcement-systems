package imagesCanBeReferencedOnlyFromAllowedRegistries

violation {
  container := input.review.object.spec.containers[_]
  satisfied := [good | repo = input.parameters.repos[_] ; good = startswith(container.image, repo)]
  not any(satisfied)
}
package imageCanBeReferencedOnlyWithImageDigest

violation {
    container := input.review.object.spec.containers[_]
    images_parts := [x | x := split(container.image, "/")]
    images_parts_without_reg := [x | x := images_parts[_]; count(x) == 0]
    image_is_without_reg := count(images_parts_without_reg) > 0
    
    default_repos := [x | x := input.parameters.repos[_]; x == ""]
    default_not_allowed := count(default_repos) == 0
    
    image_is_without_reg
    default_not_allowed
}

violation {
    container := input.review.object.spec.containers[_]
    images_parts := [x | x := split(container.image, "/")]
    images_parts_with_reg := [x | x := images_parts[_]; count(x) > 1]
    image_is_with_reg := count(images_parts_with_reg) > 0
    
    non_default_repos := [x | x := input.parameters.repos[_]; x != ""]
    
    satisfied := [good | repo = non_default_repos[_] ; good = startswith(container.image, repo)]
    only_satisfied := [s | s := satisfied[_]; s == true]
    no_registry_matches := count(only_satisfied) == 0    
    
    image_is_with_reg
    no_registry_matches  
}
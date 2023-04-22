# Playground

- folder with example input.json that can be used as an input for testing policies in playground
- rego playground - https://play.openpolicyagent.org/

- testing example
```
package play

violation {
    container := input.review.object.spec.containers[_]
	print("container:", container)
}

```
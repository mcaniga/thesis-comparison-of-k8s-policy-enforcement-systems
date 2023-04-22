# Custom policies

- folder with custom Kubewarden policies
- this policies work `kwctl run` but PolicyServer is not able to execute these wasm
- to include the policies to normal flow, move them to policies folder

```
kwctl run -e gatekeeper --request-path ../example.json ../wasm/liveness-probes-are-required.wasm | jq
```
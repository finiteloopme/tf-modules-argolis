
# Demo Overview

This demo uses a deployment of `Stable Diffusion Web UI` application.  [Stable Diffusion][3] is a `text2image` generation model.  
The application is deployed on `Kubernetes` and requires `GPU`.

At present, `GPU`s are a very scare resource.  And expensive.  So not many users _reserve_ `GPU` instances.  But prefer to use them on-demand.  
The challenge with this approach is that there is no guarantee users would be able to get any GPUs when required.  An alternative could be to use `GPU` in any available region.

We need two patterns to make this work:  

1. A global, on demand, and eventually consistent platform which can locate `GPU` and host the `Stable Diffusion` application in that region
2. A way to wire in that regional service into a global endpoint

## Show & tell

1. Global service: [Stable Diffusion Web UI][10]
2. How do you "expand" footprint in different region?
3. Multi Cluster Service & Ingress
4. To fail: use a different GPU
5. Recover the system

# Technical Stack

## GKE Autopilot

The demo highlights how [GKE Autopilot][7], can be used to _elegantly_ handle variable and underministic demands on the workload.  
Two modes of GKE:  

1. **Autopilot**: _default_ mode of operation, in which Google manages cluster configuration including nodes, scaling, security, etc.
2. **Standard**: Google manages the control plane, but user configures and manages nodes.

> [Here][8] is a feature comparison for Autopilot and Standard.  And [a guide][9] to help choose the mode of operation.

## Multi Cluster Ingress

# References

1. [GPU on Autopilot][1]
2. [Accelerators in Regions][2]
3. [Stable Diffusion Web UI][4]

## Notes

- Thank you [Sam Stoelinga][6], for [this][5] very helpful blog post.

---
[1]: https://cloud.google.com/kubernetes-engine/docs/how-to/autopilot-gpus
[2]: https://cloud.google.com/vertex-ai/docs/general/locations#accelerators
[3]: https://stability.ai/blog/stable-diffusion-public-release
[4]: https://github.com/AUTOMATIC1111/stable-diffusion-webui
[5]: https://samos-it.com/posts/deploying-stable-diffusion-gke-autopilot.html
[6]: https://github.com/samos123/
[7]: https://cloud.google.com/kubernetes-engine/docs/concepts/autopilot-overview
[8]: https://cloud.google.com/kubernetes-engine/docs/resources/autopilot-standard-feature-comparison
[9]: https://cloud.google.com/kubernetes-engine/docs/concepts/choose-cluster-mode
[10]: http://sd.kunall.demo.altostrat.com/

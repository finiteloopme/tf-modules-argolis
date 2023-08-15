
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
3. How is the app deployed using `ConfigSync`?
4. Multi Cluster Service & Ingress
5. To fail: use a different GPU
6. Recover the system

# Technical Stack

## GKE Autopilot

The demo highlights how [GKE Autopilot][7], can be used to _elegantly_ handle variable and underministic demands on the workload.  
Two modes of GKE:  

1. **Autopilot**: _default_ mode of operation, in which Google manages cluster configuration including nodes, scaling, security, etc.
2. **Standard**: Google manages the control plane, but user configures and manages nodes.

> [Here][8] is a feature comparison for Autopilot and Standard.  And [a guide][9] to help choose the mode of operation.

## Multi Cluster Ingress

[Multi Cluster Ingress][11] is a cloud-hosted controller for deploying shared load balancing resources across clusters and across regions.

Multi Cluster Ingress supports many use cases including:

1. A single, consistent virtual IP (VIP) for an app, independent of where the app is deployed globally.
2. Multi-regional, multi-cluster availability through health checking and traffic failover.
3. Proximity-based routing through public Anycast VIPs for low client latency.
4. Transparent cluster migration for upgrades or cluster rebuilds.

A **MultiClusterService** is a custom resource used by Multi Cluster Ingress to represent sharing services across clusters.

## Deployment

```bash
# clone the git repo
git clone https://github.com/finiteloopme/tf-modules-argolis
cd tf-modules-argolis/samples/autopilot-with-mci
# Deploy Infrastructure in GCP
# We assume the you have a GCP project
# And you have created a GCS bucket: ${GCP_PROJECT_ID}-tf-state
make infra-init
make infra-plan
make infra-deploy
# Deploy Stable Diffusion App
# make deploy creates a static IP, which can be found using: gcloud compute addresses list
# It should be external IP resource named: ext-sd-web-ui-mci-ip
# Set that IP as the annotation in: app/k8s-config/mci-ingress.yaml
make app-init
make app-deploy
```

## Clean up

```bash
make app-undeploy
make infra-undeploy
```

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
[11]: https://cloud.google.com/kubernetes-engine/docs/concepts/multi-cluster-ingress
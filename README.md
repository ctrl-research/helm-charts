# Helm Charts

A Helm repository for my generic, one-size-fits-all Helm chart.

## Charts

| Chart | Description |
|-------|-------------|
| [generic](charts/generic) | Deploy any application or Kubernetes resource by defining full manifests in the values file |

## Adding the Helm repository

```bash
helm repo add ctrl-research https://ctrl-research.github.io/helm-charts
helm repo update
```

Install the generic chart:

```bash
helm install myapp ctrl-research/generic --namespace myapp --create-namespace
```

## OCI registry

The generic chart is also published as an OCI artifact on GitHub Container Registry (GHCR):

```bash
helm install myapp oci://ghcr.io/ctrl-research/charts/generic --namespace myapp --create-namespace
```

Pull without installing:

```bash
helm pull oci://ghcr.io/ctrl-research/charts/generic
```

> Charts are published to GHCR automatically on each release.

## Usage

Every resource is defined as a full Kubernetes manifest under its resource-kind key. Names are automatically prefixed with the release name. See [`charts/generic/values.yaml`](charts/generic/values.yaml) for the full list of supported resource kinds.

```yaml
# values.yaml
deployments:
  web:
    metadata:
      labels:
        app: web
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: web
      template:
        metadata:
          labels:
            app: web
        spec:
          containers:
            - name: web
              image: nginx:1.27
              ports:
                - containerPort: 80

services:
  web:
    spec:
      selector:
        app: web
      ports:
        - port: 80
          targetPort: 80
```

```bash
helm install myapp ctrl-research/generic -f values.yaml
```
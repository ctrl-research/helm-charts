# Agent Guide

## Repository Structure

This repo publishes two Helm charts to GitHub Pages via `helm/chart-releaser-action`:

- **`charts/generic`** — application chart for running any Docker image. Own templates in `charts/generic/templates/` (does NOT use `common.*` templates despite the dependency).
- **`charts/common`** — library chart (`type: library`) providing reusable templates: `common.deployment`, `common.service`, `common.configmap`, `common.secret`, `common.serviceaccount`, `common.rbac`.

## Generic Chart Values Schema

Values are flat top-level keys, not a `components` map:

```yaml
deployments:
  app:
    image:
      registry: docker.io
      repository: nginx
      tag: latest
    ports:
      - name: http
        containerPort: 80
    env: []
    resources: {}
    livenessProbe: {}
    readinessProbe: {}
    volumeMounts: []
    volumes: []
    initContainers: []
    replicas: 1

services: {}
configmaps: {}
secrets: {}
serviceAccounts: {}
persistentVolumeClaims: {}
horizontalPodAutoscalers: {}
ingresses: {}
```

See `charts/generic/values.yaml` for full schema. Each key iterates independently via `range` — resource names come from the map key.

## Deployment Quirks

- Hardcoded annotation `reloader.stakater.com/auto: "true"` on every Deployment.
- Image string is always `{{ registry }}/{{ repository }}:{{ tag }}` (registry defaults to `docker.io`).
- Container name defaults to the deployment map key.

## CI/CD

- **Release** (`.github/workflows/publish_chart.yaml`): On push to `main`, runs `helm dependency update` on all charts then `helm/chart-releaser-action` to create GitHub Releases and update `gh-pages` index.
- **Renovate** (`.github/workflows/renovate.yaml`): Runs every 2 hours via self-hosted renovatebot/github-action. Config split across root `renovate.json` (schedule, docker-compose manager, labels, patch bumps) and `.github/renovate-config.js` (repo list, platform config).
- **To trigger a release**: bump `version` in a chart's `Chart.yaml`, merge to `main`.

## Gotchas

- `charts/generic/Chart.yaml` declares dependency `common: 0.3.0` but `charts/common/Chart.yaml` says `version: 0.1.0`. Chart.lock resolves to 0.1.0. Renovate bumps chart versions as `patch` updates.
- No test/lint/format/typecheck tooling configured.
- Root `renovate.json` has `enabledManagers: ["docker-compose"]` — it does NOT manage Helm chart dependencies via renovate (version bumps are manual or handled by the self-hosted config).

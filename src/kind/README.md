# Kubernetes IN Docker

![Logo](../../docs/img/kind.png)

kind is a tool for running local Kubernetes clusters using Docker
container “nodes”. kind was primarily designed for testing Kubernetes
itself, but may be used for local development or CI.

## Operating System Support Matrix

| Name     |  Version   | Supported |
| :------- | :--------: | :-------: |
| Ubuntu   |   16.04    |    [x]    |
| Ubuntu   |   18.04    |    [x]    |
| Ubuntu   |   20.04    |    [x]    |
| CentOS   |     7      |    [x]    |
| CentOS   |     8      |    [x]    |
| OpenSUSE | Tumbleweed |    [x]    |
| OpenSUSE |    Leap    |    [x]    |

## How to use it

```bash
curl -fsSL http://bit.ly/install_pkg | PKG=kind bash
```

### Environment variables

| Name             | Default | Description                                |
| :--------------- | :------ | :----------------------------------------- |
| PKG_KIND_VERSION |         | Specifies the KinD version to be installed |

### [Dev Container](https://containers.dev/overview)

This script can be consumed as Development container "Feature" through the
following configuration:

```json
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/docker-in-docker:1": {},
    "ghcr.io/electrocucaracha/pkg-mgr_scripts/kind:latest": {}
  }
}
```

## Used by

- [Kubernetes NonPreemptingPriority gate feature demo](https://github.com/electrocucaracha/k8s-NonPreemptingPriority-demo)
- [K6 Grafana Dashboard](https://github.com/electrocucaracha/k6board)
- [GW Tester Demo](https://github.com/electrocucaracha/gw-tester)

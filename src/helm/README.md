# Helm

![Logo](../../docs/img/helm.png)

Helm helps you manage Kubernetes applications — Helm Charts help you
define, install, and upgrade even the most complex Kubernetes
application.

Charts are easy to create, version, share, and publish — so start
using Helm and stop the copy-and-paste.
## Operating System Support Matrix

| Name       | Version    | Supported |
|:-----------|:----------:|:---------:|
| Ubuntu     | 16.04      | [x]       |
| Ubuntu     | 18.04      | [x]       |
| Ubuntu     | 20.04      | [x]       |
| CentOS     | 7          | [x]       |
| CentOS     | 8          | [x]       |
| OpenSUSE   | Tumbleweed | [x]       |
| OpenSUSE   | Leap       | [x]       |

## How to use it

```bash
curl -fsSL http://bit.ly/install_pkg | PKG=helm bash
```
### Environment variables

| Name                  | Default                                                         | Description                                |
|:----------------------|:----------------------------------------------------------------|:-------------------------------------------|
| PKG_HELM_VERSION      | 3                                                               | Specifies the Helm version to be installed |
| PKG_HELM_PLUGINS_LIST | ThalesGroup/helm-spray,databus23/helm-diff,datreeio/helm-datree | List of Helm plugins to be installed       |

### [Dev Container](https://containers.dev/overview)

This script can be consumed as Development container "Feature" through the
following configuration:

```json
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/electrocucaracha/pkg-mgr_scripts/helm:latest": {}
    }
}
```

## Used by

- [GW Tester Demo](https://github.com/electrocucaracha/gw-tester)
- [K6 Grafana Dashboard](https://github.com/electrocucaracha/k6board)
- [Kubernetes Reference Deployment](https://github.com/electrocucaracha/krd)

# Knative client

![Logo](../../docs/img/kn.png)

Knative is an open source community project which adds components for deploying,
running, and managing serverless, cloud-native applications to Kubernetes. The
serverless cloud computing model can lead to increased developer productivity
and reduced operational costs.

## Operating System Support Matrix

| Name     |  Version   | Supported |
| :------- | :--------: | :-------: |
| Ubuntu   |   16.04    |    [x]    |
| Ubuntu   |   18.04    |    [x]    |
| Ubuntu   |   20.04    |    [x]    |
| OpenSUSE | Tumbleweed |    [x]    |
| OpenSUSE |    Leap    |    [x]    |

## How to use it

```bash
curl -fsSL http://bit.ly/install_pkg | PKG=kn bash
```

### [Dev Container](https://containers.dev/overview)

This script can be consumed as Development container "Feature" through the
following configuration:

```json
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/electrocucaracha/pkg-mgr_scripts/kn:latest": {}
  }
}
```

### Environment variables

| Name           | Default | Description                                   |
| :------------- | :------ | :-------------------------------------------- |
| PKG_KN_VERSION |         | Specifies the Knative version to be installed |

## Used by

- [KRD](https://github.com/electrocucaracha/krd/)

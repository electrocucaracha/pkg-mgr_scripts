# Fly

A command-line interface for [Concourse CI](https://concourse-ci.org) that runs builds in containers via the ATC (Air Traffic Controller) server.

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
curl -fsSL http://bit.ly/install_pkg | PKG=fly bash
```

### [Dev Container](https://containers.dev/overview)

This script can be consumed as Development container "Feature" through the
following configuration:

```json
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/electrocucaracha/pkg-mgr_scripts/fly:latest": {}
  }
}
```

### Environment variables

| Name            | Default | Description                               |
| :-------------- | :------ | :---------------------------------------- |
| PKG_FLY_VERSION |         | Specifies the fly version to be installed |

## Used by

- [Release Engineering](https://github.com/electrocucaracha/releng)

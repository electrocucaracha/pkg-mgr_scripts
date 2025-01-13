# GitHub Actions client

![Logo](../../docs/img/act.png)

Act is an open source project that allows you to run your GitHub flow locally.

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
curl -fsSL http://bit.ly/install_pkg | PKG=act bash
```

### Environment variables

| Name            | Default | Description                               |
| :-------------- | :------ | :---------------------------------------- |
| PKG_ACT_VERSION |         | Specifies the act version to be installed |

### [Dev Container](https://containers.dev/overview)

This script can be consumed as Development container "Feature" through the
following configuration:

```json
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/electrocucaracha/pkg-mgr_scripts/act:latest": {}
  }
}
```

## Used by

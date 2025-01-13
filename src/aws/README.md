# AWS command-line

The AWS command-line Interface (AWS CLI) is an open source tool that enables you
to interact with AWS services using commands in your command-line shell.

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
curl -fsSL http://bit.ly/install_pkg | PKG=aws bash
```

### Environment variables

| Name            | Default | Description                                   |
| :-------------- | :------ | :-------------------------------------------- |
| PKG_AWS_VERSION |         | Specifies the AWS CLI version to be installed |

### [Dev Container](https://containers.dev/overview)

This script can be consumed as Development container "Feature" through the
following configuration:

```json
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/electrocucaracha/pkg-mgr_scripts/aws:latest": {}
  }
}
```

## Used by

- [Devstack labs](https://github.com/electrocucaracha/devstack-labs)

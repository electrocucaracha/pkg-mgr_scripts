# AWS Command Line Interface

The AWS Command Line Interface (AWS CLI) is an open source tool that enables you
to interact with AWS services using commands in your command-line shell.

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
curl -fsSL http://bit.ly/install_pkg | PKG=aws bash
```
### Environment variables

| Name            | Default | Description                                   |
|:----------------|:--------|:----------------------------------------------|
| PKG_AWS_VERSION |         | Specifies the AWS CLI version to be installed |

## Used by

- [Devstack labs](https://github.com/electrocucaracha/devstack-labs)

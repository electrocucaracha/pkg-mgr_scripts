# podman

![Logo](../../docs/img/podman.png)

Podman is a daemonless container engine for developing, managing, and
running OCI Containers on your Linux System. Containers can either be
run as root or in rootless mode.

## Operating System Support Matrix

| Name       | Version    | Supported |
|:-----------|:----------:|:---------:|
| Ubuntu     | 16.04      | [ ]       |
| Ubuntu     | 18.04      | [x]       |
| Ubuntu     | 20.04      | [x]       |
| CentOS     | 7          | [x]       |
| CentOS     | 8          | [x]       |
| OpenSUSE   | Tumbleweed | [x]       |
| ClearLinux |            | [ ]       |

## How to use it

```bash
curl -fsSL http://bit.ly/install_pkg | PKG=podman bash
```
### Environment variables

| Name             | Default | Description                                |
|:-----------------|:--------|:-------------------------------------------|
| PKG_CRUN_VERSION |         | Specifies the crun version to be installed |

## Used by


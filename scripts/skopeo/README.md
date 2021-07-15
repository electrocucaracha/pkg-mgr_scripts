# skopeo

![Logo](../../docs/img/skopeo.png)

skopeo is a command line utility that performs various operations on
container images and image repositories. It does not require the user
to be running as root to do most of its operations. It does not
require a daemon to be running to perform its operations. It can work
with OCI images as well as the original Docker v2 images.

## Operating System Support Matrix

| Name       | Version    | Supported |
|:-----------|:----------:|:---------:|
| Ubuntu     | 16.04      | [ ]       |
| Ubuntu     | 18.04      | [x]       |
| Ubuntu     | 20.04      | [x]       |
| CentOS     | 7          | [x]       |
| CentOS     | 8          | [x]       |
| OpenSUSE   | Tumbleweed | [x]       |
| OpenSUSE   | Leap       | [x]       |

## How to use it

```bash
curl -fsSL http://bit.ly/install_pkg | PKG=skopeo bash
```

### Environment variables

## Used by

- [Release Engineering](https://github.com/electrocucaracha/releng)
- [Bare Metal as a Service](https://github.com/electrocucaracha/bmaas)

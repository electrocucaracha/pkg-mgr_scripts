# Packer

![Logo](../../docs/img/packer.png)

HashiCorp Packer automates the creation of any type of machine image.
It embraces modern configuration management by encouraging you to use
automated scripts to install and configure the software within your
Packer-made images. Packer brings machine images into the modern age,
unlocking untapped potential and opening new opportunities.

## Operating System Support Matrix

| Name       | Version    | Supported |
|:-----------|:----------:|:---------:|
| Ubuntu     | 16.04      | [x]       |
| Ubuntu     | 18.04      | [x]       |
| Ubuntu     | 20.04      | [x]       |
| CentOS     | 7          | [x]       |
| CentOS     | 8          | [x]       |
| OpenSUSE   | Tumbleweed | [x]       |
| ClearLinux |            | [x]       |

## How to use it

```bash
curl -fsSL http://bit.ly/install_pkg | PKG=packer bash
```
### Environment variables

| Name               | Default | Description                                  |
|:-------------------|:--------|:---------------------------------------------|
| PKG_PACKER_VERSION |         | Specifies the Packer version to be installed |

## Used by


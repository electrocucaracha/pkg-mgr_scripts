# VirtualBox

![Logo](../../docs/img/virtualbox.png)

Oracle VM VirtualBox (formerly Sun VirtualBox, Sun xVM VirtualBox and
Innotek VirtualBox) is a free and open-source hosted hypervisor for
x86 virtualization.
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
curl -fsSL http://bit.ly/install_pkg | PKG=virtualbox bash
```
### Environment variables

| Name                   | Default | Description                                      |
|:-----------------------|:--------|:-------------------------------------------------|
| PKG_VIRTUALBOX_VERSION | 6.1     | Specifies the VirtualBox version to be installed |

## Used by

- [Bootstrap Vagrant](https://github.com/electrocucaracha/bootstrap-vagrant)

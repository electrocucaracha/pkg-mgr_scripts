# VirtualBox

![Logo](../../docs/img/virtualbox.png)

Oracle VM VirtualBox (formerly Sun VirtualBox, Sun xVM VirtualBox and
Innotek VirtualBox) is a free and open-source hosted hypervisor for
x86 virtualization.

## Operating System Support Matrix

| Name     |  Version   | Supported |
| :------- | :--------: | :-------: |
| Ubuntu   |   22.04    |    [x]    |
| Ubuntu   |   24.04    |    [x]    |
| OpenSUSE | Tumbleweed |    [x]    |
| OpenSUSE |    Leap    |    [x]    |

## How to use it

```bash
curl -fsSL http://bit.ly/install_pkg | PKG=virtualbox bash
```

### Environment variables

| Name                   | Default | Description                                      |
| :--------------------- | :------ | :----------------------------------------------- |
| PKG_VIRTUALBOX_VERSION | 7.2     | Specifies the VirtualBox version to be installed |

## Used by

- [Bootstrap Vagrant](https://github.com/electrocucaracha/bootstrap-vagrant)

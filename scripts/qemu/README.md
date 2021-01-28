# QEMU

![Logo](../../docs/img/qemu.png)

QEMU is a hosted virtual machine monitor: it emulates the machine's
processor through dynamic binary translation and provides a set of
different hardware and device models for the machine, enabling it to
run a variety of guest operating systems. It also can be used with KVM
to run virtual machines at near-native speed (by taking advantage of
hardware extensions such as Intel VT-x). QEMU can also do emulation
for user-level processes, allowing applications compiled for one
architecture to run on another.

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
curl -fsSL http://bit.ly/install_pkg | PKG=qemu bash
```
### Environment variables

| Name              | Default | Description                                 |
|:------------------|:--------|:--------------------------------------------|
| PKG_QEMU_VERSION  | 5.2.0   | Specifies the QEMU version to be installed  |
| PKG_PMDK_VERSION  | 1.4     | Specifies the PMDK version to be installed  |
| PKG_NINJA_VERSION |         | Specifies the Ninja version to be installed |

## Used by

- [Bootstrap Vagrant](https://github.com/electrocucaracha/bootstrap-vagrant)

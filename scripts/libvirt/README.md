# Libvirt

![Logo](../../docs/img/libvirt.png)

Libvirt is an open-source API, daemon and management tool for managing
platform virtualization. It can be used to manage KVM, Xen, VMware
ESXi, QEMU and other virtualization technologies. These APIs are
widely used in the orchestration layer of hypervisors in the
development of a cloud-based solution.

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
curl -fsSL http://bit.ly/install_pkg | PKG=libvirt bash
```
### Environment variables

| Name             | Default | Description                                |
|:-----------------|:--------|:-------------------------------------------|

## Used by

- [Bootstrap Vagrant](https://github.com/electrocucaracha/bootstrap-vagrant)

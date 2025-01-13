# Vagrant

![Logo](../../docs/img/vagrant.png)

Vagrant is an open-source software product for building and
maintaining portable virtual software development environments, e.g.
for VirtualBox, KVM, Hyper-V, Docker containers, VMware, and AWS. It
tries to simplify the software configuration management of
virtualizations in order to increase development productivity. Vagrant
is written in the Ruby language, but its ecosystem supports
development in a few languages.

## Operating System Support Matrix

| Name     |  Version   | Supported |
| :------- | :--------: | :-------: |
| Ubuntu   |   16.04    |    [ ]    |
| Ubuntu   |   18.04    |    [x]    |
| Ubuntu   |   20.04    |    [x]    |
| CentOS   |     7      |    [x]    |
| CentOS   |     8      |    [x]    |
| OpenSUSE | Tumbleweed |    [x]    |
| OpenSUSE |    Leap    |    [x]    |

## How to use it

```bash
curl -fsSL http://bit.ly/install_pkg | PKG=vagrant bash
```

### Environment variables

| Name                | Default | Description                                   |
| :------------------ | :------ | :-------------------------------------------- |
| PKG_VAGRANT_VERSION |         | Specifies the Vagrant version to be installed |

## Used by

- [Bootstrap Vagrant](https://github.com/electrocucaracha/bootstrap-vagrant)

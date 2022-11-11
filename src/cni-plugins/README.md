# Container Network Interface plugins

![Logo](../../docs/img/cni-plugins.png)

CNI (_Container Network Interface_), a [Cloud Native Computing Foundation](https://cncf.io)
project, consists of a specification and libraries for writing plugins
to configure network interfaces in Linux containers, along with a
number of supported plugins. CNI concerns itself only with network
connectivity of containers and removing allocated resources when the
container is deleted. Because of this focus, CNI has a wide range of
support and the specification is simple to implement.

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
curl -fsSL http://bit.ly/install_pkg | PKG=cni-plugins bash
```
### Environment variables

| Name                            | Default                          | Description                                                |
|:--------------------------------|:---------------------------------|:-----------------------------------------------------------|
| PKG_CNI_PLUGINS_VERSION         |                                  | Specifies the CNI plugins version to be installed          |
| PKG_CNI_PLUGINS_FOLDER          | /opt/containernetworking/plugins | Defines the destination folder for the CNI plugin binaries |
| PKG_FLANNEL_VERSION             |                                  | Specifies the Flannel CNI version to be installed          |
| PKG_CNI_PLUGINS_INSTALL_FLANNEL | false                            | Installs Flannel CNI into the CNI folder                   |

## Used by

- [GW Tester Demo](https://github.com/electrocucaracha/gw-tester/)

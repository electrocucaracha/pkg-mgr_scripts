# Docker

![Logo](../../docs/img/docker.png)

Docker is a set of platform as a service (PaaS) products that use
OS-level virtualization to deliver software in packages called
containers. Containers are isolated from one another and bundle their
own software, libraries and configuration files; they can communicate
with each other through well-defined channels. All containers are run
by a single operating-system kernel and are thus more lightweight than
virtual machines.

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
curl -fsSL http://bit.ly/install_pkg | PKG=docker bash
```
### Environment variables

| Name                             | Default                                                               | Description                                                                         |
|:---------------------------------|:----------------------------------------------------------------------|:------------------------------------------------------------------------------------|
| PKG_DOCKER_INSECURE_REGISTRIES   |                                                                       | Determines the insecure registries to configure                                     |
| PKG_DOCKER_DEFAULT_ADDRESS_POOLS | {"base":"172.80.0.0/16","size":24},{"base":"172.90.0.0/16","size":24} | Defines the subnet network that Docker will pick to local scope networks            |
| PKG_DOCKER_REGISTRY_MIRRORS      |                                                                       | Defines a list of Docker registries                                                 |
| PKG_REGCLIENT_VERSION            |                                                                       | Specifies the [regclient](https://github.com/regclient/regclient) version           |
| PKG_DOCKER_ENABLE_USERNS_REMAP   | false                                                                 | Enables [UserNS Remap](https://docs.docker.com/engine/security/userns-remap/)       |
| PKG_DOCKER_SLIM_VERSION          |                                                                       | Specifies the [docker-slim](https://github.com/docker-slim/docker-slim) version     |
| PKG_DOCKER_INSTALL_ROOTLESS      | false                                                                 | Installs [Rootless mode](https://docs.docker.com/engine/security/rootless/)         |
| PKG_DOCKER_INSTALL_REGCTL        | false                                                                 | Installs [Registry API client](https://github.com/regclient/regclient)              |
| PKG_DOCKER_INSTALL_DOCKER_SLIM   | false                                                                 | Installs [DockerSlim tool](https://dockersl.im/)                                    |
| PKG_DOCKER_INSTALL_GVISOR        | false                                                                 | Installs [gVisor runtime](https://gvisor.dev/)                                      |
| PKG_DOCKER_INSTALL_DIVE          | false                                                                 | Installs [dive](https://github.com/wagoodman/dive)                                  |
| PKG_DOCKER_DIVE_VERSION          |                                                                       | Specifies the [dive](https://github.com/wagoodman/dive) version                     |

## Used by

- [GW Tester Demo](https://github.com/electrocucaracha/gw-tester)
- [cURL package installer - Local Web server](https://github.com/electrocucaracha/pkg-mgr)
- [K6 Grafana Dashboard](https://github.com/electrocucaracha/k6board)
- [GrimoireLab Cloud-Native](https://github.com/electrocucaracha/grimoirelab)
- [Kubernetes Reference Deployment](https://github.com/electrocucaracha/krd)
- [OpenStack Multi-Node Deployment](https://github.com/electrocucaracha/openstack-multinode)
- [Firewall Cloud-Native Network Function Demo](https://github.com/electrocucaracha/cFW-demo)
- [Kubernetes Development Environment](https://github.com/electrocucaracha/kubernetes-dev)
- [Kubernetes NonPreemptingPriority gate feature demo](https://github.com/electrocucaracha/k8s-NonPreemptingPriority-demo)
- [CentOS Mirror Server](https://github.com/electrocucaracha/centos-mirror)
- [QAT enablement on OKD](https://github.com/electrocucaracha/okd)
- [Bare Metal as a Service](https://github.com/electrocucaracha/bmaas)

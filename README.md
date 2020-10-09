# cURL package installer
[![Build Status](https://travis-ci.org/electrocucaracha/pkg-mgr_scripts.png)](https://travis-ci.org/electrocucaracha/pkg-mgr_scripts)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Docker Pulls](https://img.shields.io/docker/pulls/electrocucaracha/pkg_mgr-init.svg)](https://img.shields.io/docker/pulls/electrocucaracha/pkg_mgr-init)

This project pretends to centralize and facilitate the process to
install and configure some Linux projects on major different Linux
Distributions.

## Supported distributions

| Name       | Version           |
|:-----------|:-----------------:|
| Ubuntu     | 16.04/18.04/20.04 |
| CentOS     | 7/8               |
| OpenSUSE   | Tumbleweed        |
| ClearLinux | 33500             |

## How to use this script?

The [install.sh](install.sh) bash script has been created to abstract
the differences between different Linux distributions. For example, in
order to install and configure Docker service the following
instruction is needed:

    curl -fsSL http://bit.ly/install_pkg | PKG="docker docker-compose" bash

`bit.ly/install_pkg` redirects to the install script in this repository and the invocation above is equivalent to:

    curl -fsSL https://raw.githubusercontent.com/electrocucaracha/pkg-mgr_scripts/master/install.sh | PKG="docker docker-compose" bash

### Program environment variables

| Name         | Description                                                               |
|:-------------|:--------------------------------------------------------------------------|
| PKG          | Package name(s) to be installed on the requester.(String value)           |
| PKG_UPDATE   | Update package manager metadata information.(Boolean value)               |
| PKG_DEBUG    | Enable verbose output during the execution.(Boolean value)                |

### Bindep usage

The cURL package installer can be combined with [bindep tool][1] to
perform multiOS installations. The following example demostrates how
to install the [Portable Hardware Locality tools][2] in the current
node.

```bash
curl -fsSL http://bit.ly/install_pkg | PKG=bindep bash

cat << EOF > bindep.txt
hwloc [node]
hwloc-lstopo [node platform:suse]
EOF
curl -fsSL http://bit.ly/install_pkg | PKG="$(bindep node -b)" bash

lstopo-no-graphics
```

[1]: https://docs.openstack.org/infra/bindep/
[2]: https://www.open-mpi.org/projects/hwloc/

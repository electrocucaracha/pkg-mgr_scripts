# cURL package installer
[![Build Status](https://travis-ci.org/electrocucaracha/pkg-mgr_scripts.png)](https://travis-ci.org/electrocucaracha/pkg-mgr_scripts)

This project pretends to centralize and facilitate the process to
install and configure some Linux projects on major different Linux
Distributions.

## Supported distributions

| Name       | Version     |
|:-----------|:-----------:|
| Ubuntu     | 16.04/18.04 |
| CentOS     | 7/8         |
| OpenSUSE   | Tumbleweed  |
| ClearLinux | 32030       |

## How to use this script?

The [install.sh](install.sh) bash script has been created to abstract
the differences between different Linux distributions. For example, in
order to install and configure Docker service the following
instruction is needed:

    curl -fsSL http://bit.ly/install_pkg | PKG="docker docker-compose" bash

## License

Apache-2.0

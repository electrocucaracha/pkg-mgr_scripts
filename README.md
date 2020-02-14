# cURL package installer
[![Build Status](https://travis-ci.org/electrocucaracha/pkg-mgr.png)](https://travis-ci.org/electrocucaracha/pkg-mgr)
[![Go Report Card](https://goreportcard.com/badge/github.com/electrocucaracha/pkg-mgr)](https://goreportcard.com/report/github.com/electrocucaracha/pkg-mgr)
[![GoDoc](https://godoc.org/github.com/electrocucaracha/pkg-mgr?status.svg)](https://godoc.org/github.com/electrocucaracha/pkg-mgr)

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

    curl -fsSL http://bit.ly/pkgInstall | PKG="docker docker-compose" bash

## How to deploy it locally?

This project includes the code of a Web Server which can be deployed
locally. The purpose of this local server is to collect information
about package's usage and centralize the installation recipes for a
development team. This initiative is under development but it can be
tested using the following instructions.

    curl -fsSL http://bit.ly/pkgInstall | PKG="docker docker-compose make git" bash
    newgrp docker
    git clone --depth 1 https://github.com/electrocucaracha/pkg-mgr
    cd pkg-mgr/
    make install

Once it's deployed locally, it's possible to consume the scripts
with the following instruction:

    curl -fsSL http://localhost:3000/pkgInstall?pkg=terraform | bash

## License

Apache-2.0

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

## License

Apache-2.0

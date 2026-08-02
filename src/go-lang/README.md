# Go

![Logo](../../docs/img/go-lang.png)

Go is a statically typed, compiled programming language designed at Google
by Robert Griesemer, Rob Pike, and Ken Thompson. Go is syntactically
similar to C, but with memory safety, garbage collection, structural
typing, and CSP-style concurrency.

## Operating System Support Matrix

| Name     |  Version   | Supported |
| :------- | :--------: | :-------: |
| Ubuntu   |   16.04    |    [x]    |
| Ubuntu   |   18.04    |    [x]    |
| Ubuntu   |   20.04    |    [x]    |
| OpenSUSE | Tumbleweed |    [x]    |
| OpenSUSE |    Leap    |    [x]    |

## How to use it

```bash
curl -fsSL http://bit.ly/install_pkg | PKG=go-lang bash
source /etc/profile.d/path.sh
```

### [Dev Container](https://containers.dev/overview)

This script can be consumed as Development container "Feature" through the
following configuration:

```json
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/electrocucaracha/pkg-mgr_scripts/go-lang:latest": {}
  }
}
```

### Environment variables

| Name               | Default | Description                              |
| :----------------- | :------ | :--------------------------------------- |
| PKG_GOLANG_VERSION |         | Specifies the Go version to be installed |

## Used by

- [QAT enablement on OKD](https://github.com/electrocucaracha/okd)
- [GW Tester Demo](https://github.com/electrocucaracha/gw-tester)
- [Bare Metal as a Service](https://github.com/electrocucaracha/bmaas)

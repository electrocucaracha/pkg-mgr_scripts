# Fly

A command-line interface that runs a build in a container with ATC.

## Operating System Support Matrix

| Name     |  Version   | Supported |
| :------- | :--------: | :-------: |
| Ubuntu   |   16.04    |    [x]    |
| Ubuntu   |   18.04    |    [x]    |
| Ubuntu   |   20.04    |    [x]    |
| CentOS   |     7      |    [x]    |
| CentOS   |     8      |    [x]    |
| OpenSUSE | Tumbleweed |    [x]    |
| OpenSUSE |    Leap    |    [x]    |

## How to use it

```bash
curl -fsSL http://bit.ly/install_pkg | PKG=fly bash
```

### Environment variables

| Name            | Default | Description                               |
| :-------------- | :------ | :---------------------------------------- |
| PKG_FLY_VERSION |         | Specifies the fly version to be installed |

## Used by

- [Release Engineering](https://github.com/electrocucaracha/releng)

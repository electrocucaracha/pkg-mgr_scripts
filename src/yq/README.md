# yq

a lightweight and portable command-line YAML processor. yq uses jq
like syntax but works with yaml files as well as json. It doesn't yet
support everything jq does - but it does support the most common
operations and functions, and more is being added continuously.

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
curl -fsSL http://bit.ly/install_pkg | PKG=yq bash
```

### Environment variables

| Name           | Default | Description                              |
| :------------- | :------ | :--------------------------------------- |
| PKG_YQ_VERSION |         | Specifies the yq version to be installed |

## Used by

# Gomplate

gomplate is a template renderer which supports a growing list of
datasources, such as: JSON (including EJSON - encrypted JSON), YAML,
AWS EC2 metadata, BoltDB, Hashicorp Consul and Hashicorp Vault
secrets.

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
curl -fsSL http://bit.ly/install_pkg | PKG=gomplate bash
```

### Environment variables

| Name                 | Default | Description                                    |
| :------------------- | :------ | :--------------------------------------------- |
| PKG_GOMPLATE_VERSION |         | Specifies the gomplate version to be installed |

## Used by

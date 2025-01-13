# QuickAssist Technology

The Intel® QuickAssist Technology (QAT) improves performance
offloading the encryption/decryption and compression/decompression
operations thereby reserving processor cycles for application and
control processing.

## Operating System Support Matrix

| Name     |  Version   | Supported |
| :------- | :--------: | :-------: |
| Ubuntu   |   16.04    |    [x]    |
| Ubuntu   |   18.04    |    [x]    |
| Ubuntu   |   20.04    |    [x]    |
| OpenSUSE | Tumbleweed |    [ ]    |
| OpenSUSE |    Leap    |    [x]    |

## How to use it

```bash
curl -fsSL http://bit.ly/install_pkg | PKG=qat-driver bash
```

### Environment variables

| Name                   | Default            | Description                                      |
| :--------------------- | :----------------- | :----------------------------------------------- |
| PKG_QAT_DRIVER_VERSION | 1.7.l.4.11.0-00001 | Specifies the QAT driver version to be installed |

## Used by

- [Bootstrap Vagrant](https://github.com/electrocucaracha/bootstrap-vagrant)

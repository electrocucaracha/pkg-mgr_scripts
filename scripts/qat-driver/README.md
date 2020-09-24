# QuickAssist Technology

The Intel® QuickAssist Technology (QAT) improves performance
offloading the encryption/decryption and compression/decompression
operations thereby reserving processor cycles for application and
control processing.

## Operating System Support Matrix

| Name       | Version    | Supported |
|:-----------|:----------:|:---------:|
| Ubuntu     | 16.04      | [x]       |
| Ubuntu     | 18.04      | [x]       |
| Ubuntu     | 20.04      | [ ]       |
| CentOS     | 7          | [x]       |
| CentOS     | 8          | [x]       |
| OpenSUSE   | Tumbleweed | [ ]       |
| ClearLinux |            | [x]       |

## How to use it

```bash
curl -fsSL http://bit.ly/install_pkg | PKG=qat-driver bash
```

## Used by

- [Bootstrap Vagrant](https://github.com/electrocucaracha/bootstrap-vagrant)

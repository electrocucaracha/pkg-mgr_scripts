# Haskell Dockerfile Linter

![Logo](../../docs/img/hadolint.png)

A smarter Dockerfile linter that helps you build best practice Docker
images. The linter is parsing the Dockerfile into an AST and performs
rules on top of the AST. It is standing on the shoulders of ShellCheck
to lint the Bash code inside RUN instructions.

## Operating System Support Matrix

| Name       | Version    | Supported |
|:-----------|:----------:|:---------:|
| Ubuntu     | 16.04      | [ ]       |
| Ubuntu     | 18.04      | [x]       |
| Ubuntu     | 20.04      | [x]       |
| CentOS     | 7          | [ ]       |
| CentOS     | 8          | [x]       |
| OpenSUSE   | Tumbleweed | [x]       |

## How to use it

```bash
curl -fsSL http://bit.ly/install_pkg | PKG=hadolint bash
```
### Environment variables

| Name                 | Default | Description                                    |
|:---------------------|:--------|:-----------------------------------------------|
| PKG_HADOLINT_VERSION |         | Specifies the Hadolint version to be installed |

## Used by

- [Kubernetes Horizontal Pod Autoscaler](https://github.com/electrocucaracha/k8s-HorizontalPodAutoscaler-demo/)

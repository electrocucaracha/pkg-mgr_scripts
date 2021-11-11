# Kustomize

![Logo](../../docs/img/kustomize.png)

Kustomize provides a solution for customizing Kubernetes resource
configuration free from templates and DSLs.

Kustomize lets you customize raw, template-free YAML files for
multiple purposes, leaving the original YAML untouched and usable as
is.

Kustomize targets kubernetes; it understands and can patch kubernetes
style API objects. It’s like make, in that what it does is declared in
a file, and it’s like sed, in that it emits edited text.

## Operating System Support Matrix

| Name       | Version    | Supported |
|:-----------|:----------:|:---------:|
| Ubuntu     | 16.04      | [x]       |
| Ubuntu     | 18.04      | [x]       |
| Ubuntu     | 20.04      | [x]       |
| CentOS     | 7          | [x]       |
| CentOS     | 8          | [x]       |
| OpenSUSE   | Tumbleweed | [x]       |
| OpenSUSE   | Leap       | [x]       |

## How to use it

```bash
curl -fsSL http://bit.ly/install_pkg | PKG=kustomize bash
```
### Environment variables

| Name                  | Default | Description                                     |
|:----------------------|:--------|:------------------------------------------------|
| PKG_KUSTOMIZE_VERSION |         | Specifies the Kustomize version to be installed |

## Used by


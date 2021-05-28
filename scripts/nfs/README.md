# Network File System

Network File System (NFS) is a distributed file system protocol
originally developed by Sun Microsystems (Sun) in 1984, allowing a
user on a client computer to access files over a computer network much
like local storage is accessed. NFS, like many other protocols, builds
on the Open Network Computing Remote Procedure Call (ONC RPC) system.
The NFS is an open standard defined in a Request for Comments (RFC),
allowing anyone to implement the protocol.

## Operating System Support Matrix

| Name       | Version    | Supported |
|:-----------|:----------:|:---------:|
| Ubuntu     | 16.04      | [x]       |
| Ubuntu     | 18.04      | [x]       |
| Ubuntu     | 20.04      | [x]       |
| CentOS     | 7          | [x]       |
| CentOS     | 8          | [x]       |
| OpenSUSE   | Tumbleweed | [x]       |

## How to use it

```bash
curl -fsSL http://bit.ly/install_pkg | PKG=nfs bash
```
### Environment variables

| Name             | Default | Description                                |
|:-----------------|:--------|:-------------------------------------------|

## Used by

- [Bootstrap Vagrant](https://github.com/electrocucaracha/bootstrap-vagrant)

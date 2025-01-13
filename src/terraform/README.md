# Terraform

![Logo](../../docs/img/terraform.png)

Terraform is an open-source infrastructure as code software tool
created by HashiCorp. It enables users to define and provision a
datacenter infrastructure using a high-level configuration language
known as Hashicorp Configuration Language (HCL), or optionally JSON.
Terraform supports a number of cloud infrastructure providers such as
Amazon Web Services, IBM Cloud (formerly Bluemix), Google Cloud
Platform, DigitalOcean, Linode, Microsoft Azure, Oracle Cloud
Infrastructure, OVH, or VMware vSphere as well as OpenNebula and
OpenStack.

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
curl -fsSL http://bit.ly/install_pkg | PKG=terraform bash
```

### Environment variables

| Name                       | Default | Description                                          |
| :------------------------- | :------ | :--------------------------------------------------- |
| PKG_TERRAFORM_VERSION      |         | Specifies the Terraform version to be installed      |
| PKG_TERRAFORM_DOCS_VERSION |         | Specifies the Terraform docs version to be installed |
| PKG_TERRASCAN_VERSION      |         | Specifies the Terrascan version to be installed      |

## Used by

- [Devstack labs](https://github.com/electrocucaracha/devstack-labs)

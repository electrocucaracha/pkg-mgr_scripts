# Helm installer

Installs the Helm package manager for Kubernetes.

## Overview

This reference describes the script entry point and its implementation helpers. Configure optional behavior with PKG_ environment variables documented in the component readme.

## Index

- [install_pkgs](#install_pkgs)
- [_install_helm_plugin](#_install_helm_plugin)
- [main](#main)

### install_pkgs

Installs supplied packages with the detected operating system package manager.

#### Arguments

- **...** (string): Package names to install.

#### Variables set

- **INSTALLER_CMD** (string): Command used to install packages.

### _install_helm_plugin

Installs a Helm plugin from its GitHub repository when it is not already installed.

#### Arguments

- **$1** (string): GitHub repository in owner/repository form.

### main

Runs this script's installation or validation workflow.

_Function has no arguments._

#### Exit codes

- **0**: When the workflow completes successfully.
- **1**: When a required command fails.

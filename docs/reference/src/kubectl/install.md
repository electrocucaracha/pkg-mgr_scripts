# Kubectl installer

Installs kubectl and its Krew plugin manager.

## Overview

This reference describes the script entry point and its implementation helpers. Configure optional behavior with PKG_ environment variables documented in the component readme.

## Index

- [install_pkgs](#install_pkgs)
- [_vercmp](#_vercmp)
- [get_github_latest_release](#get_github_latest_release)
- [_install_finalize_namespace](#_install_finalize_namespace)
- [main](#main)

### install_pkgs

Installs supplied packages with the detected operating system package manager.

#### Arguments

- **...** (string): Package names to install.

#### Variables set

- **INSTALLER_CMD** (string): Command used to install packages.

### _vercmp

Compares two version strings using the supplied comparison operator.

#### Arguments

- **$1** (string): First version.
- **$2** (string): Comparison operator: ==, >, <, >=, or <=.
- **$3** (string): Second version.

#### Exit codes

- **0**: When the comparison is true.
- **1**: When the comparison is false or the operator is invalid.

### get_github_latest_release

Resolves the latest GitHub release version for a repository.

#### Arguments

- **$1** (string): GitHub repository in owner/repository form.

#### Exit codes

- **1**: When the latest release cannot be resolved after retries.

#### Output on stdout

- Latest release version without the v prefix.

### _install_finalize_namespace

Installs the optional kubectl-finalize_namespace plugin.

_Function has no arguments._

### main

Runs the Kubectl installation workflow.

_Function has no arguments._

#### Exit codes

- **0**: When the workflow completes successfully.
- **1**: When a required command fails.

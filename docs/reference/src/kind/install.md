# Kind installer

Installs Kubernetes in Docker.

## Overview

This reference describes the script entry point and its implementation helpers. Configure optional behavior with PKG_ environment variables documented in the component readme.

## Index

- [install_pkgs](#install_pkgs)
- [get_github_latest_release](#get_github_latest_release)
- [main](#main)

### install_pkgs

Installs supplied packages with the detected operating system package manager.

#### Arguments

- **...** (string): Package names to install.

#### Variables set

- **INSTALLER_CMD** (string): Command used to install packages.

### get_github_latest_release

Resolves the latest GitHub release version for a repository.

#### Arguments

- **$1** (string): GitHub repository in owner/repository form.

#### Exit codes

- **1**: When the latest release cannot be resolved after retries.

#### Output on stdout

- Latest release version without the v prefix.

### main

Runs this script's installation or validation workflow.

_Function has no arguments._

#### Exit codes

- **0**: When the workflow completes successfully.
- **1**: When a required command fails.

# Docker installer

Installs Docker and optional Docker utilities.

## Overview

This reference describes the script entry point and its implementation helpers. Configure optional behavior with PKG_ environment variables documented in the component readme.

## Index

- [get_github_latest_release](#get_github_latest_release)
- [_install_gvisor](#_install_gvisor)
- [_install_regctl](#_install_regctl)
- [_install_dive](#_install_dive)
- [main](#main)

### get_github_latest_release

Resolves the latest GitHub release version for a repository.

#### Arguments

- **$1** (string): GitHub repository in owner/repository form.

#### Exit codes

- **1**: When the latest release cannot be resolved after retries.

#### Output on stdout

- Latest release version without the v prefix.

### _install_gvisor

Installs the gVisor runtime binaries.

_Function has no arguments._

### _install_regctl

Installs the regctl container registry client and Docker plugin.

_Function has no arguments._

### _install_dive

Installs the Dive container image analysis tool.

_Function has no arguments._

### main

Runs this script's installation or validation workflow.

_Function has no arguments._

#### Exit codes

- **0**: When the workflow completes successfully.
- **1**: When a required command fails.

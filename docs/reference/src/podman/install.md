# Podman installer

Installs Podman container tools.

## Overview

This reference describes the script entry point and its implementation helpers. Configure optional behavior with PKG_ environment variables documented in the component readme.

## Index

- [_vercmp](#_vercmp)
- [get_github_latest_release](#get_github_latest_release)
- [_install_runc](#_install_runc)
- [_install_crun](#_install_crun)
- [_install_youki](#_install_youki)
- [main](#main)

### _vercmp

Compares two version strings using the supplied comparison operator.

#### Arguments

- **$1** (string): First version.
- **$2** (string): Comparison operator: equal, greater than, less than, greater than or equal, or less than or equal.
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

### _install_runc

Installs the runc Open Container Initiative runtime.

_Function has no arguments._

### _install_crun

Installs the crun Open Container Initiative runtime.

_Function has no arguments._

### _install_youki

Installs the youki Open Container Initiative runtime.

_Function has no arguments._

### main

Runs this script's installation or validation workflow.

_Function has no arguments._

#### Exit codes

- **0**: When the workflow completes successfully.
- **1**: When a required command fails.

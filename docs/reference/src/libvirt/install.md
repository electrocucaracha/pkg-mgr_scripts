# Libvirt installer

Installs Libvirt virtualization tools.

## Overview

This reference describes the script entry point and its implementation helpers. Configure optional behavior with PKG_ environment variables documented in the component readme.

## Index

- [_vercmp](#_vercmp)
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

### main

Runs this script's installation or validation workflow.

_Function has no arguments._

#### Exit codes

- **0**: When the workflow completes successfully.
- **1**: When a required command fails.

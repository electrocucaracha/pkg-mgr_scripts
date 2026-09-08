# Crystal installer

Installs the Crystal programming language.

## Overview

This reference describes the script entry point and its implementation helpers. Configure optional behavior with PKG_ environment variables documented in the component readme.

## Index

- [install_pkgs](#install_pkgs)
- [main](#main)

### install_pkgs

Installs supplied packages with the detected operating system package manager.

#### Arguments

- **...** (string): Package names to install.

#### Variables set

- **INSTALLER_CMD** (string): Command used to install packages.

### main

Runs this script's installation or validation workflow.

_Function has no arguments._

#### Exit codes

- **0**: When the workflow completes successfully.
- **1**: When a required command fails.

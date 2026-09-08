# AWS installer

Installs AWS command-line tools.

## Overview

This reference describes the script entry point and its implementation helpers. Configure optional behavior with PKG_ environment variables documented in the component readme.

## Index

- [install_pkgs](#install_pkgs)
- [get_github_latest_tag](#get_github_latest_tag)
- [main](#main)

### install_pkgs

Installs supplied packages with the detected operating system package manager.

#### Arguments

- **...** (string): Package names to install.

#### Variables set

- **INSTALLER_CMD** (string): Command used to install packages.

### get_github_latest_tag

Resolves the latest GitHub tag for a repository.

#### Arguments

- **$1** (string): GitHub repository in owner/repository form.

#### Exit codes

- **1**: When the latest tag cannot be resolved after retries.

#### Output on stdout

- Latest tag version without the v prefix.

### main

Runs this script's installation or validation workflow.

_Function has no arguments._

#### Exit codes

- **0**: When the workflow completes successfully.
- **1**: When a required command fails.

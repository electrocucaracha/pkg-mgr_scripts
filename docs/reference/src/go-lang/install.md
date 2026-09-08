# Go installer

Installs the Go programming language.

## Overview

This reference describes the script entry point and its implementation helpers. Configure optional behavior with PKG_ environment variables documented in the component readme.

## Index

- [get_go_latest_version](#get_go_latest_version)
- [main](#main)

### get_go_latest_version

Resolves the latest Go release version from the official Go distribution endpoint.

#### Exit codes

- **1**: When the version cannot be resolved after retries.

#### Output on stdout

- Latest Go version without the go prefix.

### main

Runs this script's installation or validation workflow.

_Function has no arguments._

#### Exit codes

- **0**: When the workflow completes successfully.
- **1**: When a required command fails.

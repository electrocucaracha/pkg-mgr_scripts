# Terraform validator

Validates a Terraform installation.

## Overview

This reference describes the script entry point and its implementation helpers. Configure optional behavior with PKG_ environment variables documented in the component readme.

## Index

- [info](#info)
- [error](#error)
- [_print_msg](#_print_msg)
- [get_version](#get_version)
- [_vercmp](#_vercmp)

### info

Writes an informational message.

#### Arguments

- **$1** (string): Message to write.

#### Output on stdout

- Message prefixed with INFO.

### error

Writes an error message and stops execution.

#### Arguments

- **$1** (string): Message to write.

#### Exit codes

- **1**: Always.

#### Output on stdout

- Message prefixed with ERROR.

### _print_msg

Formats and writes a message with its severity level.

#### Arguments

- **$1** (string): Message severity.
- **$2** (string): Message content.

#### Output on stdout

- Formatted severity and message.

### get_version

Resolves the tool version expected by this validator.

#### Exit codes

- **1**: When the version cannot be resolved after retries.

#### Output on stdout

- Expected tool version.

### _vercmp

Compares two version strings using the supplied comparison operator.

#### Arguments

- **$1** (string): First version.
- **$2** (string): Comparison operator: equal, greater than, less than, greater than or equal, or less than or equal.
- **$3** (string): Second version.

#### Exit codes

- **0**: When the comparison is true.
- **1**: When the comparison is false or the operator is invalid.

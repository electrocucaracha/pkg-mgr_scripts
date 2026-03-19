// SPDX-license-identifier: Apache-2.0
// Copyright (c) 2025 All rights reserved.
// Apache License, Version 2.0 - http://www.apache.org/licenses/LICENSE-2.0

const jsoncPlugin = require("eslint-plugin-jsonc");

// Use JSONC-recommended config which allows comments in JSON files.
// This handles devcontainer-feature.json files that contain // comments
// as markers for the automated version update process.
module.exports = [...jsoncPlugin.configs["flat/recommended-with-jsonc"]];

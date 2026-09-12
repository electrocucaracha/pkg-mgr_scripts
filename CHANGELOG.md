<!-- Markdownlint-disable MD024 -->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [54.0.0] - 2026-09-12

### Removed

- Simplified CI configuration by consolidating spell checking into a single tool, eliminating the redundant reviewdog-based misspelling check job from the workflow. [8e4edb7d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8e4edb7db61d5d1a35b72287072cf111a0a1ac9b)

## [53.2.1] - 2026-09-12

### Changed

- Updated the pre-commit configuration to use the latest version of the ai-prepare-commit-msg hook, now at v16.3.0, to ensure the project benefits from the latest features and fixes. [b089b5b3](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b089b5b3132ef871f34ecd7715cb1e588fe0d506)

## [53.2.0] - 2026-09-07

### Added

- Enabled auto-generated Markdown reference files for each installer and validator script under the docs/reference directory, improving discoverability and maintainability of the shell-based feature modules. [cd85fe12](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/cd85fe1254dd9bfb45132f643d979bec717776ab)

## [53.1.1] - 2026-08-16

### Changed

- Updated pinned versions to reflect newer dependencies, requiring users to update their dependencies accordingly. [81ca9c79](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/81ca9c79e05ceb95b653dff47f8c588ddd63cd4c)

## [53.1.0] - 2026-08-16

### Added

- Enabled consistent terminology across the codebase by enforcing it through automated textlint checks as part of the formatting process. [f6270c8d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f6270c8d772d4257a24fdbbeaef7d8552718eefb)

## [53.0.2] - 2026-08-14

### Changed

- Updated dictionary definitions and pinned versions to 2.36.24 and 8.3.0 respectively, affecting the AWS CLI and Fly versions used in development containers. [58a0635e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/58a0635ed2ee785873eb81776ae4084fea877adb)

## [53.0.1] - 2026-08-07

### Changed

- Upgraded the dictionary definitions and pinned versions file to reflect the latest available versions, which may require migration steps to ensure compatibility. [f40da331](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f40da331c98dabc0908e4729d4dbe8a3935ef317)

## [53.0.0] - 2026-08-05

### Removed

- Simplified the codebase by eliminating unnecessary devcontainer-feature definitions for libvirt, qemu, and virtualbox, which were no longer relevant due to feature management elsewhere. [2f6463c6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2f6463c6a0cf60ff412812810b55127dd268bf17)

## [52.1.2] - 2026-08-04

### Fixed

- Resolves SOCKS proxy setup reliability issues for users behind a proxy by ensuring the chameleonsocks installation script receives proxy configuration variables when run with sudo. [8c462f9d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8c462f9d07a4f363dfc35000bf3625d4f5cc1b3b)

## [52.1.1] - 2026-08-04

### Fixed

- Stabilized CI matrix generation to correctly handle full distro blacklists, preventing malformed queries and ensuring no CI failures when no supported distros remain. [98a13964](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/98a13964b5f1b0d882555b6927f80f209be06dec)

## [52.1.0] - 2026-08-04

### Added

- Expanded the OS blacklist to include additional unsupported distributions, ensuring consistent enforcement of unsupported OS policies across all components and reducing the risk of accidental usage on untested or end-of-life platforms. [f1115f83](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f1115f83e3c6390d0ae68d1e0c821f246c38fa29)

## [52.0.3] - 2026-08-04

### Changed

- Upgraded the ai-prepare-commit-msg hook to the latest revision, ensuring compatibility with recent pre-commit features and incorporating upstream improvements and bugfixes without requiring configuration updates. [6efc8d11](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6efc8d11c90a5e0023b95d51a8faa81cd59a6cbe)

## [52.0.2] - 2026-08-04

### Fixed

- Stabilized the sudo fallback function to prevent unexpected failures when called with no arguments or only options, ensuring robustness and compatibility across all install and validate scripts. [c90c2bec](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c90c2becaeb362c9de45c5a39ae155e91b4605c6)

## [52.0.1] - 2026-08-04

### Fixed

- Resolved compatibility issues with scripts that include sudo flags by correcting the sudo fallback to handle options like -E or -n when invoked with sudo, and improved the CNI plugins test to check both legacy and new plugin install locations. [bda9802d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bda9802dc8b90da58dc27f1a7fd886659da352c9)

## [52.0.0] - 2026-08-04

### Removed

- Simplified the .yamllint configuration file by removing unnecessary empty lines, resulting in a cleaner and more maintainable configuration that adheres to standard YAML linter formatting practices. [dd904fb5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/dd904fb5c6d580609d0ae3a07f6c377bfc9baeae)

## [51.0.0] - 2026-08-04

### Removed

- Stabilized the os-blacklist.conf file by removing trailing whitespace after comments to prevent unnecessary diffs and linting failures in some environments. [ca3ba316](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ca3ba31696822f347da1847fb11a3cd74a16715d)

## [50.5.0] - 2026-08-04

### Added

- Enabled more accurate documentation linting by introducing the term "pre" to the wordlist. [a9b35170](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a9b3517088a5dd40bf04c73e0b04f32bab26efa5)

## [50.4.0] - 2026-08-04

### Added

- Enabled local sudo fallback in all install and validate scripts, allowing installers to work seamlessly whether run as root or a non-root user and ensuring correct permissions in multi-user environments. [c015bb69](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c015bb6967be7b10131b507076bc853671aefdae)

## [50.3.6] - 2026-08-04

### Fixed

- Scripts that run as root without sudo now work by providing a local fallback for sudo, ensuring compatibility across environments. [ac48cd7d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ac48cd7d644d3d005e192123c90727f87a09de9a)

## [50.3.5] - 2026-08-04

### Fixed

- Stabilized compatibility across environments by providing a local sudo fallback when running as root without sudo, and improved the exportfs check to verify both the command's presence in PATH and its existence at /usr/sbin/exportfs, preventing false negatives and ensuring robust installation and testing in diverse container setups. [a77aee14](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a77aee142635452a9f78a033e141c19e5cf0487a)

## [50.3.4] - 2026-08-04

### Fixed

- Resolved issues with devcontainer images that run installers as root without sudo by providing a local sudo fallback, and improved the reliability of the CNI bridge plugin test to check both legacy and current paths. [77c94ca9](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/77c94ca96a3135511c5798790636aca4de380404)

## [50.3.3] - 2026-08-04

### Changed

- Clarified the mermaid flowchart in the README.md file to more accurately reflect the install script's logic and improve readability for new contributors. [ee054130](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ee0541305643388ec1069169a1cc59a8a68332db)

## [50.3.2] - 2026-08-04

### Fixed

- The script now tolerates apt install failures, allowing VirtualBox tools to be usable even if the install step fails in container environments without kernel headers. [5ba656a8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5ba656a8c97960fe99981c3956da961e270ed598)

## [50.3.1] - 2026-08-04

### Fixed

- Restricted Skopeo installation checks to only apply to Ubuntu, ensuring correct behavior on Debian systems by utilizing the standard apt repository. [b97c432e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b97c432e3359f432c7ae0caa383d053000d8c471)

## [50.3.0] - 2026-08-04

### Added

- Enabled system-wide availability of rustfmt by symlinking it to /usr/local/bin during installation, ensuring consistent formatting command execution for users regardless of their PATH configuration. [850b0a89](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/850b0a8972482ea03857100b058753e4c8107843)

## [50.2.8] - 2026-08-04

### Fixed

- resolved installation failures for Debian systems by correctly selecting the repository based on the Linux distribution and version. [ca92fbbb](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ca92fbbb5eaa930a2971c1dd30fd067882386da1)

## [50.2.7] - 2026-08-04

### Fixed

- The qat-driver scripts now stabilize their behavior in minimal environments by skipping installation and validation logic if the lspci command is missing, matching the behavior when no QAT hardware is detected and improving robustness on systems without PCI utilities. [866f9e82](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/866f9e8248409be291c7ae12c0a130740b619adb)

## [50.2.6] - 2026-08-04

### Fixed

- Resolved unnecessary Go version validation failures by allowing prefix matching for version checks. [5f044733](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5f044733abfefc16771ac833cfda934cabc1f12e)

## [50.2.5] - 2026-08-04

### Fixed

- Stabilized the installation process for Rocky Linux by ensuring the Docker CE repository can be added on fresh systems and verifying the Docker CLI version after installation. [1a72379a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1a72379af63cb76cd5dbe87be6038a6bf135c8ce)

## [50.2.4] - 2026-08-04

### Fixed

- Stabilized the test job's command to correctly handle script names with special characters or spaces, and set the base image statically to the Ubuntu devcontainer image for improved consistency across runs. [88546934](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/885469348ebfe835092a1dd19f46449113cfbfe3)

## [50.2.3] - 2026-08-04

### Fixed

- Resolved the Debian version check issue in the Docker installer, ensuring accurate configuration for certain versions by correctly evaluating the version check for Debian systems with VERSION_ID less than 12. [e3290485](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e3290485ee3e5bd561da12415554a205ad846b90)

## [50.2.2] - 2026-08-04

### Fixed

- Refined the workflow's permissions for improved security by switching from a broad "read-all" permission to a more restricted "contents: read" permission, and hardened the workflow by passing secrets and matrix variables through environment variables instead of directly in run steps. [9e6909a5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/9e6909a535f42921bd1a0c49b524a4ae819b5366)

## [50.2.1] - 2026-08-04

### Fixed

- Improved installation robustness and developer experience by enabling adaptive hardware detection, streamlining package management, and simplifying privilege requirements for tools and QAT driver installation. [04d6459b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/04d6459b94131fe86c0dcca05a8c6b6d05729672)

## [50.2.0] - 2026-08-04

### Added

- Enabled idempotent installation and debug logging for buildah across multiple distributions, while also improving systemd detection to prevent errors on non-systemd systems and enhance service management robustness. [8cd66673](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8cd66673fc318f8e2290d942a88577411e97f889)

## [50.1.0] - 2026-08-04

### Added

- Enabled proper recognition of runtime-related terms in spelling and terminology checks during CI, reducing false positives and improving developer experience. [acc38e39](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/acc38e39b0cb37115dd708a03886e607ca4ceabe)

## [50.0.3] - 2026-08-04

### Changed

- Clarified the project's purpose and scope in the readme file, simplifying and centralizing installation and configuration of Linux tools across major distributions for improved readability by new users. [dc068f3f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/dc068f3f668eddad32ed9afbb7cc8ce0a4b5ac74)

## [50.0.2] - 2026-08-04

### Changed

- Streamlined documentation for Dev Container users by enabling them to easily consume these scripts as Development container Features and simplifying documentation maintenance through improved clarity and consistency. [d166fed0](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d166fed055778867a13b55ed6aa3cc744a73862b)

## [50.0.1] - 2026-08-04

### Fixed

- Stabilized test scenarios and container service management by adding missing test cases and correcting systemctl usage in containers. [3d9c5c32](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3d9c5c3291931c636eaa098f7f644fcc3e540cc2)

## [50.0.0] - 2026-08-01

### Removed

- Simplified the formatting of workflow files by enforcing consistent spacing before inline comments and requiring EOF newlines. [f821cf3b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f821cf3bf0baca7d0a1cdffd84b4454d58d11cd5)

## [49.0.2] - 2026-08-01

### Changed

- Feature tests are now executed as part of the release workflow to prevent publishing untested features. [b6f6488e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b6f6488e50f52f665c58f8777be8bb4201b48eb4)

## [49.0.1] - 2026-08-01

### Changed

- Enabled automated commit message preparation and version tracking for devcontainer-feature.json files, reducing manual maintenance and preventing formatting drift. [db00e60d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/db00e60d28c9c5dbe0729e8d9163f6190434473d)

## [49.0.0] - 2026-08-01

### Removed

- BREAKING: Simplified test maintenance by replacing legacy shell-based validation scripts with unified, feature test-compatible scripts for Docker, Helm, Kind, and kubectl, and removing legacy test scripts for act, aws, cni-plugins, and kubectl plugins, requiring downstream consumers to migrate to the new test structure. [859429ee](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/859429ee85ba99b116a161a55a986559c04fe717)

## [48.0.1] - 2026-08-01

### Changed

- Optimized the release workflow to use a manual feature publishing process with Node.js setup, enabling finer control over the publish step and easier troubleshooting. [cdaedadd](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/cdaedadd4f5133d8d114becfb2a7c2da89bdb0f8)

## [48.0.0] - 2026-08-01

### Removed

- Simplified the development workflow for Buildah by eliminating unnecessary devcontainer feature and test script. [7b49c2e7](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7b49c2e7f22c1af1963813f56c9128a0c5179d2f)

## [47.2.1] - 2026-08-01

### Fixed

- Enabled direct invocation of test scripts in Unix environments by updating file permissions to allow execution. [02792b5c](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/02792b5cb93f7b17b29ed366547368a33cf6e43d)

## [47.2.0] - 2026-08-01

### Added

- Enabled consistent environment dependency verification for test and automation workflows by introducing installation validation scripts for common command-line tools. [194ae9c6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/194ae9c69052b659e82ca4c990164d436dc1ba60)

## [47.1.1] - 2026-08-01

### Changed

- Standardized GitHub Actions in workflow files to use "v" prefixed tags, improving clarity and reliability of automated updates. [5aaa2337](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5aaa233789bfb671c3150e4c4621d1637c636daf)

## [47.1.0] - 2026-08-01

### Added

- Enabled consistent configuration and discoverability for multiple tools in devcontainer environments by introducing devcontainer-feature definitions for pip, podman, qat-driver, qemu, rust-lang, skopeo, terraform, tkn, vagrant, virtualbox, and yq, each with a pkg_debug boolean option defaulting to true for verbosity. [4cd3a60e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/4cd3a60e1acf1be1c04d15df0c3931c9fdeb04d1)

## [47.0.6] - 2026-07-31

### Changed

- Optimized the GitHub Actions workflow for linting by updating the versions of the GitHub Actions Markdown link checker and the GitHub super-linter tool. [a58a081b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a58a081b75f7f192def650e35df4daf2cbbb111b)

## [47.0.5] - 2026-07-30

### Fixed

- The kind autocomplete validation in the test script now accurately reflects the install state by sourcing the kind autocomplete file if present before checking for the _kind function. [f13be023](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f13be023eff2a78d5d731aa3e3a1cf46bc222504)

## [47.0.4] - 2026-07-30

### Fixed

- Simplified the Node.js version selection process for SUSE installations to dynamically use the provided version variable, enabling greater flexibility and consistency across distributions. [b542fc10](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b542fc1049384c2cd2dd7064f456633216a4684c)

## [47.0.3] - 2026-07-30

### Fixed

- Resolved the validation step to accurately identify missing autocomplete script installations by explicitly sourcing the script before checking for the _kustomize function. [273623a4](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/273623a478ca04e7bf5414e4682c651402ed5de6)

## [47.0.2] - 2026-07-30

### Fixed

- Stabilized the installation script's kustomize version check to prevent false negatives and ensure robustness against changes in kustomize's output format. [576f1ae6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/576f1ae635e62e8ce4d6fa38b5aa4622a2124786)

## [47.0.1] - 2026-07-30

### Fixed

- Resolved false negatives in the validation script by ensuring the autocomplete script is loaded before checking for the _kn function. [eef028bf](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/eef028bfb5dae2b393890357a13a0796e3d831fd)

## [47.0.0] - 2026-07-30

### Removed

- The version comparison in the kind install script now accurately matches versions with and without the 'v' prefix, preventing unnecessary reinstalls. [35143df5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/35143df57278793514e37745afe970b6b28fefb5)

## [46.0.0] - 2026-07-30

### Removed

- Corrected the installation process by eliminating the -slim suffix from the gomplate binary name, ensuring that the correct binary is downloaded for all platforms. [07eb85f7](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/07eb85f7f478c5381dae350152665aa20c05e7ec)

## [45.1.4] - 2026-07-30

### Fixed

- Resolved the issue of false negatives in the validation script by ensuring the autocomplete script is loaded before checking for the _fly function. [8f05ec2a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8f05ec2afd722808d04a465138f72a4966345fef)

## [45.1.3] - 2026-07-30

### Fixed

- Stabilized installer compatibility with openSUSE Leap versions by dynamically inserting the detected VERSION_ID into the repository URL. [60e1cecc](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/60e1cecc1af766bf0d98b2799362d611ad658768)

## [45.1.2] - 2026-07-30

### Changed

- Updated the CI environment to use the latest stable releases of several tools to ensure compatibility, security, and reliability, with no breaking changes expected but requiring downstream consumers to verify integration with the updated toolchain. [6e90f18a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6e90f18a40218060c23b18287797a53e3c176b8b)

## [45.1.1] - 2026-07-30

### Changed

- Updated default tool versions in devcontainers to their latest or specified stable releases, ensuring new devcontainers are provisioned with up-to-date tooling and improving compatibility and reducing manual intervention. [6695c421](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6695c421fca8b0aa56761f6df5fc809ce14fc6e2)

## [45.1.0] - 2026-07-30

### Added

- Enabled flexible configuration of tool installation in development containers through the introduction of devcontainer-feature.json files for multiple tools, including Buildah, Docker, Fly CLI, Go, Gomplate, Hadolint, Knative CLI, Kustomize, Libvirt, NFS Utilities, and Node.js. [3b61d881](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3b61d881f706b2f721e2b4499c8e640b194b9070)

## [45.0.3] - 2026-07-30

### Fixed

- Improved pip command availability and validation by enabling the use of python -m pip, which ensures the correct interpreter is used and works even if only python or python3 is available. [3aa6637d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3aa6637dff8266301aebb39f96be27aaa7d65899)

## [45.0.2] - 2026-07-30

### Changed

- Updated GitHub Actions dependencies to their latest stable versions, ensuring continued compatibility and support through addressed upstream bugfixes and security improvements. [17a15774](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/17a1577487561342f9b805e6e01ec3104bced6c6)

## [45.0.1] - 2026-07-30

### Changed

- Standardized GitHub Actions versions for lint, spell check, and update workflows to ensure consistent behavior across the repository. [632ab33c](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/632ab33ce5efb8de849b18fd1d35fd511f8577a3)

## [45.0.0] - 2026-07-30

### Removed

- Simplified the setup process by removing an unused tox setting and updating Python command resolution to correctly handle variable values. [d6ddf4f4](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d6ddf4f48ea9b8ed799eb91dda1ad38164eb263b)

## [44.0.1] - 2026-07-27

### Fixed

- Stabilized the installation process for Python and pip on Debian, Ubuntu, and RHEL-based systems by ensuring the correct Python interpreter is used and pip is installed for the intended version, reducing the risk of breaking system Python. [b4581866](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b4581866bae2897dad300f2823df73d8175e8628)

## [44.0.0] - 2026-04-22

### Removed

- Eliminated the automatic rebase feature for pull requests, requiring users to manually rebase their pull requests. [2dccd328](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2dccd328925f781456a100964cda0bc069f3b8af)

## [43.0.0] - 2026-04-22

### Removed

- Downgraded the AWS CLI version mismatch warning to a warning from an error and removed EOL Debian Buster support from the package manager scripts. [8c390e96](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8c390e963d405faaac35654ac32152c139de2afb)

## [42.1.1] - 2026-04-22

### Changed

- Updated dictionary definitions and incremented pinned package versions in CI and devcontainer configurations to reflect the changes. [1591acb8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1591acb895fcbe3302c81b728143c340b41db040)

## [42.1.0] - 2026-03-24

### Added

- Trigger spell check CI on wordlist and spell check config changes enabling continuous spell checking on updates to the wordlist and spell check configuration. [4bce670f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/4bce670f60ee92a2d808b544a3c34d3358111018)

## [42.0.1] - 2026-03-24

### Fixed

- resolved the race condition in the check-dictionary job by isolating dictionary updates with a distinct branch name. [305dc11f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/305dc11fa06c8874d7fe94867a45cdc9ee80d5cf)

## [42.0.0] - 2026-03-24

### Removed

- Eliminated two words from the GitHub wordlist file, 'demonstrates' and 'runtime', which may cause issues if used in code or configuration files. [8653e9ce](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8653e9cebd37ddd8603064a3b10d91833d27f865)

## [41.7.7] - 2026-03-22

### Fixed

- Enabled successful create-pr-action push by restoring Git credentials and disabling JSON validation. [ebd1bff7](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ebd1bff71b530927153243546ad7aa9d1edf8c2c)

## [41.7.6] - 2026-03-18

### Fixed

- Updated linting configuration to support JSONC syntax in devcontainer feature files, enabling automated version updates while preserving comments. [96a20f35](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/96a20f35fa65c972ac24aee0ad1ab8c3d8664b92)

## [41.7.5] - 2026-03-18

### Fixed

- The GitHub workflow now correctly handles the term 'runtime' due to the resolution of spelling errors in the wordlist used by the workflow. [941a1186](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/941a1186917061112828a6594be3a2379900f208)

## [41.7.4] - 2026-03-18

### Changed

- Resolved all 29 GITHUB_ACTIONS_ZIZMOR super-linter findings and updated GitHub Actions to the latest versions, resulting in improved security and compliance for workflow files. [8391dbde](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8391dbdece456b60945a28ea9447223514da7923)

## [41.7.3] - 2026-03-12

### Changed

- Optimized super-linter CI by enabling full Git history checkout, resolving failures and fixing yamllint truthy warning without breaking any API contract or requiring migration. [f3607eac](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f3607eaccba20a1da8dad52e27c81d6eab45a554)

## [41.7.2] - 2026-03-12

### Changed

- Upgraded pinned versions to ensure consistency across environments and align with current dependencies. [e7f17506](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e7f17506baa074c8743a171deff43daf1cda825c)

## [41.7.1] - 2026-01-26

### Changed

- Updated multiple GitHub Actions workflows to utilize the latest versions of go-version and other actions, with no breaking behavior or migration requirements introduced. [15d8515b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/15d8515baf1c3f7e2d6998d661fe192ad21ecdd0)

## [41.7.0] - 2026-01-26

### Added

- Scheduled distro updates are now enabled to occur every 5 days instead of every 1 day, reducing the frequency of the scheduled verification process. [49e84b5f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/49e84b5f03614a98fefacbed8d7da4be4f47c3ea)

## [41.6.4] - 2025-11-17

### Changed

- Updated GitHub Actions workflows to use newer versions of actions and tools, requiring potential updates to maintain compatibility with the updated versions of actions/cache@4.3.0, actions/checkout@5.0.1, calibreapp/image-actions@1.4.1, and super-linter/super-linter@8.2.1. [09a7cfe7](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/09a7cfe76f1725e68f15c4534236565499d4ccd2)

## [41.6.3] - 2025-10-11

### Changed

- Updated the supported Ubuntu versions for VirtualBox installation to 22.04 and 24.04, replacing 16.04, 18.04, and 20.04, with no migration steps required. [0b232018](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/0b23201842ac29a825a0d75885f0087688559171)

## [41.6.2] - 2025-09-14

### Changed

- The pip installation script now correctly handles Python versions prior to 3.9, ensuring a smooth installation experience for users with older Python versions. [894ff93e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/894ff93e2ee0fdc3df6714e7635c924ae7a30ba6)

## [41.6.1] - 2025-09-05

### Changed

- Updated pinned versions in the project's dependencies and devcontainer-feature.json files, requiring users to update their configurations to the new default versions. [c77988a6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c77988a6e772b1cb587568970263486f96a0e9c3)

## [41.6.0] - 2025-08-12

### Added

- Standardized YAML formatting has been enabled across all configuration files, introducing a consistent format and improving readability, with no breaking changes. [f2254235](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f2254235f84f4b8f1703cc8ac30dc1247e7d37c4)

## [41.5.0] - 2025-08-12

### Added

- Enabled automatic default branch detection for the super-linter in the GitHub workflow, allowing for improved linter flexibility and adaptability to different repository configurations. [bb6d7fe8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bb6d7fe854fe3856ede96dcc94d962370b69823b)

## [41.4.1] - 2025-08-12

### Changed

- Optimized the GitHub labeler action to require a token with read and write permissions to pull requests, affecting the workflow triage.yml which uses the action to assign labels. [ea0bed05](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ea0bed05fa660d56003c30799efad0d6473d7dd1)

## [41.4.0] - 2025-07-11

### Added

- Enabled exclusion of the `spec/*` directory from linting by updating the `.github/workflows/lint.yml` and `Makefile` configurations, and introducing a new `FILTER_REGEX_EXCLUDE` variable in the config schema, allowing users and maintainers to review and adjust their linting configurations accordingly. [8276f216](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8276f216e3fee357823a82e56030d83483f61ce2)

## [41.3.5] - 2025-07-11

### Changed

- Corrected typos and improved clarity in the readme files for kubectl, NFS, and yq, enhancing documentation accuracy without introducing any breaking behavior or API changes. [490f0ff2](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/490f0ff26502a5985fe57f440fbe79ce8e96053b)

## [41.3.4] - 2025-07-11

### Changed

- The EditorConfig configuration was updated to use a checker file instead of the main EditorConfig file, and related workflows and scripts were modified to accommodate this change. [3f1f7581](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3f1f7581228dc3aa565848b459d2c57ed7dcd3a0)

## [41.3.3] - 2025-07-11

### Changed

- Stabilized the identation parameter in the Makefile to use 4 spaces instead of the default, affecting the behavior of the `shfmt` command. [3117fd66](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3117fd660dd32d7730f0fdfe1a522c9d32e5dde0)

## [41.3.2] - 2025-06-24

### Changed

- Updated the default versions used in development containers and workflows to newer versions, including act, AWS CLI, and several other dependencies, potentially requiring updates to dependent projects. [76d49c89](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/76d49c89a1b823ddb59e3fe1a5c19895ef11df04)

## [41.3.1] - 2025-05-26

### Changed

- Updated pinned versions of various dependencies to newer values. [c314d83a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c314d83a5c05a21b3283c0023bb25efb64a0526a)

## [41.3.0] - 2025-04-09

### Added

- Enabled support for JSON files by adding a configuration that disables comments, affecting users who write JSON files and requiring them to update their configuration to avoid linting errors. [43d188ad](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/43d188ad9e3d16e6f8c4c85491a56cdcabe17a22)

## [41.2.1] - 2025-04-09

### Changed

- Updated the GitHub Actions workflow to directly use the super-linter repository, ensuring the latest version 7.3.0 is utilized without introducing breaking behavior or requiring migration steps. [40484da5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/40484da5a5594eb8431ba22f7fbdfb60cb0c0a85)

## [41.2.0] - 2025-04-09

### Added

- Enabled the enforcement of code style consistency by requiring users to create an .editorconfig file in their project root, which must be present to avoid linting errors. [1c27419a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1c27419a7358cfccd9f2f93e9ce9fb580becb034)

## [41.1.3] - 2025-04-09

### Changed

- Updated GitHub workflows to enable access to necessary repository information for various actions such as compressing images, distros, linting, rebasing, releasing, spell checking, and triage, without introducing any breaking behavior or API changes. [6c7bab4f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6c7bab4f8ed10145fe2edea6d14b8959951afa71)

## [41.1.2] - 2025-02-16

### Changed

- Upgraded pinned versions of various packages in the project's CI configuration and devcontainer features to the latest available versions. [cdb90eb4](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/cdb90eb4e84bef08e58c1009d71d303ca3ef347d)

## [41.1.1] - 2025-02-13

### Changed

- Updated dictionary definitions to reflect new dependencies. [f8f1f814](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f8f1f81459b8ea1c29f23e6a2e3cda15d8685274)

## [41.1.0] - 2025-02-04

### Added

- Introduced a secret token, WORKFLOW_TOKEN, for GitHub workflow authentication, enabling the workflow to write contents and workflows without the need for Personal Access Tokens. [fddabf0f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/fddabf0f8aa7f813d3538ae6d493cc11373cbfa9)

## [41.0.5] - 2025-02-02

### Changed

- Enabled write access to packages, contents, and pull requests in the GitHub Actions devcontainer, allowing the release workflow to function correctly and publish features. [d53c7ded](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d53c7ded13f18e80c6d950581381a3d0a94689c1)

## [41.0.4] - 2025-02-02

### Changed

- Upgraded the GitHub Actions workflow to use newer versions of the actions/checkout and gaurav-nelson/github-action-markdown-link-check actions, and updated the actions/setup-go action to version 5.3.0, which may require migration to the new version of Go. [9fc09983](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/9fc099835b0de6a759b52607aa349477de9153ec)

## [41.0.3] - 2025-02-02

### Changed

- Updated default package versions in devcontainers to reflect values specified in devcontainer-feature.json files. [76c99e84](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/76c99e84d4cc8358870055cb9e30a802a856285a)

## [41.0.2] - 2025-02-01

### Changed

- Upgraded pinned versions in the CI environment to newer versions, including act, aws, cni-plugins, crun, and several others, with most seeing a one or two version bump, potentially requiring migration steps for users relying on the previous versions. [8007b272](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8007b272a6c47f5a4df839cd8ae0dbf842f764d3)

## [41.0.1] - 2025-01-22

### Changed

- The pip script now correctly handles Debian and Ubuntu systems, enabling a smoother installation process for pip on these platforms. [fe6c5250](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/fe6c5250a13256e5c612533da65feb682197c327)

## [41.0.0] - 2025-01-12

### Removed

- The build process is now reliant on alternative tasks and pipelines following the removal of Tekton support. [46f3188a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/46f3188ad2348cdb890078df895285bfe1494c28)

## [40.1.0] - 2025-01-12

### Added

- Enabled GitHub Actions configuration to specify the execution of vagrant boxes, improving the setup and workflow for users. [8efc96be](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8efc96bebe7c27be9acdf246dcf4d66e34ff012d)

## [40.0.1] - 2025-01-12

### Changed

- The default permissions for Bash executables are now set correctly by the spec installation process, enabling it to function as intended. [569cd456](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/569cd456a5d3cda11d5841e957a5ac91bd5a6fa8)

## [40.0.0] - 2025-01-12

### Removed

- Simplified the repository's workflow by dropping Dependabot and updating GitHub Actions to use newer versions, requiring a manual migration to the new versions. [5225d24e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5225d24e6e7c9d9512e72f35bd184a466a0f0a04)

## [39.0.0] - 2025-01-12

### Removed

- Eliminated CentOS 7 and 8 from the list of supported distributions, impacting users who relied on these versions for development and testing. [4fb616de](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/4fb616de31f679607cb8e6a9f5f2c19c7d7ea8f2)

## [38.7.33] - 2025-01-12

### Changed

- Optimized the super-linter tool by updating its Docker image reference to ghcr.io/super-linter/super-linter, ensuring compatibility and proper functionality without affecting the API or CLI contract. [2a37992a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2a37992ad2b74e89cb4a1b69d60860ad7cc4b637)

## [38.7.32] - 2025-01-12

### Changed

- Updated GitHub Actions workflows, Docker configurations, and package installations to improve project setup and tooling. [12adc959](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/12adc9592405fd042d2033375dfbf61cb7577316)

## [38.7.31] - 2025-01-12

### Changed

- Workflows can now run on users' own machines, replacing the previous requirement to run on macOS-12. [a6e41aec](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a6e41aec965ef09be63e4a1594ca7da6b3b22cda)

## [38.7.30] - 2025-01-07

### Changed

- Optimized the installation script for libvirt to correctly handle Rocky Linux, resulting in improved socket access permissions and package installation. [158613c6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/158613c6b82a7a6dbf14764e5f14c7277ae4046a)

## [38.7.29] - 2024-12-11

### Changed

- Updated the actions/setup-go dependency to version 5.2.0, requiring a minor update to workflow configurations to ensure the latest version of Go is installed. [25b82b5a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/25b82b5a0c77381bbe9ab27bc40026a4b4c184e8)

## [38.7.28] - 2024-12-06

### Changed

- Optimized the actions/cache dependency to version 4.2.0, which may require migrating workflows that use the cache action. [c964ae96](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c964ae9699df1250f6aa2e13581c932e251f7e3d)

## [38.7.27] - 2024-12-05

### Changed

- Modernized spell checking behavior by updating the reviewdog/action-misspell dependency from version 1.25.0 to 1.26.1, which may require users to re-run their spell checks to take advantage of any new features or bugfixes. [65620563](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/656205630c2598dd6b53153b8b7d89668855db76)

## [38.7.26] - 2024-12-03

### Changed

- Upgraded the spell checking tool in GitHub Actions workflows to the latest version, enabling more accurate and comprehensive spell checking. [63bccbd7](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/63bccbd7ee83cf21dc16f63aa017a3619c95a1ef)

## [38.7.25] - 2024-10-25

### Changed

- Optimized the setup-go action in GitHub workflows to version 5.1.0, which includes bugfixes and improvements for installing Go dependencies, with no API or CLI contract changes and no migration steps required. [dfeab7a5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/dfeab7a5ede01321f1e4ed177ba7b0e019167feb)

## [38.7.24] - 2024-10-24

### Changed

- Updated the actions/checkout dependency to version 4.2.2, ensuring that all dependent workflows utilize the latest version of this dependency without introducing any breaking behavior or API changes. [c8046bb2](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c8046bb2c537e230806beb0b39fa1c3e1d55677d)

## [38.7.23] - 2024-10-23

### Changed

- Updated the cache action in GitHub Actions workflows to version 4.1.2. [45c78b49](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/45c78b49488b609f93cfcefb655fb3f549365bd0)

## [38.7.22] - 2024-10-09

### Changed

- Updated the actions/cache dependency to the latest patch version 4.1.1, ensuring the workflow continues to run smoothly without introducing any breaking behavior or migration requirements. [b6ef2f62](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b6ef2f62ae79c36d5601a34b5777c14b4ae36e98)

## [38.7.21] - 2024-10-08

### Changed

- Updated the dependency on actions/checkout to version 4.2.1, which does not introduce any breaking behavior or migration requirements. [4df964ad](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/4df964adeab0fbb722ff9ae529de4dfc01ea5ec7)

## [38.7.20] - 2024-10-07

### Changed

- Updated the devcontainers/action dependency to version 1.4.3, a minor patch release that does not introduce any breaking changes. [012ca101](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/012ca101cf5b77fc482eaa6b412b7df500318c39)

## [38.7.19] - 2024-10-07

### Changed

- Upgraded the actions/cache dependency to version 4.1.0, potentially requiring users of this dependency to review release notes for performance improvements or bugfixes. [279b783e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/279b783e674b7bcd536c5bad9ebef5a0afb7bb43)

## [38.7.18] - 2024-09-26

### Changed

- Upgraded the actions/checkout dependency to version 4.2.0, a minor update that maintains compatibility with existing GitHub workflows. [3a84e0e1](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3a84e0e1d9eed915e79e27b8df26c1e2ce4a2893)

## [38.7.17] - 2024-09-17

### Changed

- Updated the dependency luizm/action-sh-checker to version 0.9.0, enabling new features and improvements in workflows that utilize the action. [112160cf](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/112160cfc7f21c533acfad6b526613908ebd7a09)

## [38.7.16] - 2024-07-15

### Changed

- modernized the reviewdog/action-misspell action to version 1.23.0, introducing minor changes to spell checking without affecting the API or CLI contract. [d2773222](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d277322243b8ff582efd9c3947f6581d7e801147)

## [38.7.15] - 2024-07-11

### Changed

- Upgraded the Go setup action in the lint workflow to version 5.0.2, ensuring a stable and up-to-date environment for Go development without introducing any breaking behavior or migration requirements. [1e4930f1](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1e4930f1f805bde0223267c24ae00d144168285c)

## [38.7.14] - 2024-07-08

### Changed

- Optimized the spell checking workflow by upgrading the reviewdog/action-misspell dependency to version 1.22.0, introducing new features or improvements without introducing breaking changes. [19555822](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/195558221b5967d99e8e6a42b9f46846613525fe)

## [38.7.13] - 2024-06-24

### Changed

- Upgraded the reviewdog/action-misspell action to version 1.21.0, enabling improved spell checking functionality in the .github/workflows/spell.yml file without introducing any breaking changes. [18eed6ad](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/18eed6adbe9bcafa10727fedbe1db709ba571009)

## [38.7.12] - 2024-06-18

### Changed

- Updated the reviewdog/action-misspell dependency to version 1.20.0, introducing minor improvements to spell checking in workflows without any breaking behavior or migration requirements. [2ac59d21](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2ac59d212082e25c05a9e31b165bb725d3a4183a)

## [38.7.11] - 2024-06-13

### Changed

- Updated the workflow dependencies to use the latest version of the actions/checkout action, which is a patch release with no breaking behavior or migration requirements. [f21fb86d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f21fb86d6c76f2ec5328bfc7c5cf9bb57e315d72)

## [38.7.10] - 2024-06-10

### Changed

- Updated the reviewdog/action-misspell action to version 1.19.0, introducing potential changes to spell checking workflows that may require manual review. [e3feaf8c](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e3feaf8c5f1b9f1474bbed0d07075be4aba71fa4)

## [38.7.9] - 2024-06-05

### Changed

- Modernized spell checking for GitHub workflows with the update of reviewdog/action-misspell from version 1.17.0 to 1.18.0, which introduces new features or bugfixes without requiring migration steps. [fac4dad7](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/fac4dad79e36a7eae3dfb7f6aa20b64f3909b2b5)

## [38.7.8] - 2024-05-18

### Changed

- The kubectl installation script has been optimized to correctly set ownership of the installed krew directory. [1b7cd365](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1b7cd3659bdc6c6d94e63e668d77b2e995120816)

## [38.7.7] - 2024-05-17

### Changed

- Modernized the kubectl script to no longer support CentOS, requiring users on this platform to explore alternative deployment options. [d06364e8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d06364e80aaf0c90a6e23fbd6d6976a6c2b6531a)

## [38.7.6] - 2024-05-17

### Changed

- Enabled running tests in a containerized environment through the addition of devcontainer test scenarios in kubectl, which affects the installation and validation of plugins, including krew and finalize_namespace. [b68e681f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b68e681ff0c4e0875304624ca33a6385ffa7173d)

## [38.7.5] - 2024-05-17

### Changed

- Enabled devcontainer test scenarios to run without the --skip-scenarios flag, simplifying the test command and allowing for more comprehensive testing. [b0f5fa53](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b0f5fa53dc3ea948828255d5963ad177c7e9376c)

## [38.7.4] - 2024-05-17

### Changed

- Upgraded the versions of various packages in the ci/pinned_versions.env file, including Docker and AWS, to newer versions, potentially requiring updates to dependent projects. [3e4c4c07](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3e4c4c0781f26a97fdbedc7b4c51dca3104ab328)

## [38.7.3] - 2024-05-17

### Changed

- Upgraded the workflow to utilize the latest version of the `actions/checkout` action, specifically version 4.1.6, which is a minor patch update with no observable impact on the workflow's behavior or functionality. [45bc1593](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/45bc159391d57cd4aee3f6c578107b3fd22088ad)

## [38.7.2] - 2024-05-07

### Changed

- Updated the dependency for actions/checkout to version 4.1.5, which has no breaking changes or API/CLI contract changes and does not require any migration steps. [c9dfbb6f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c9dfbb6f826c4f07ee87534774f78f368ebb54ef)

## [38.7.1] - 2024-05-03

### Changed

- Updated the Go setup action in GitHub workflows to version 5.0.1, a minor patch release with no breaking behavior or migration requirements. [59249d6e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/59249d6e85cecc45cf11d56caf0c0c977f9624dd)

## [38.7.0] - 2024-04-26

### Added

- Introduced SCC badges and a GitHub Action to display code size and complexity metrics on the readme, triggered on push and pull requests. [6e91fb0f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6e91fb0f0a29b291f1ccad9a93e515bd53f250a1)

## [38.6.8] - 2024-04-25

### Changed

- Updated the actions/checkout dependency to version 4.1.4, a minor patch update that likely includes bugfixes or minor improvements with no breaking behavior or migration requirements. [f9c3e8f9](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f9c3e8f990dd4c04f6ea06c5e0c0bbccc893a627)

## [38.6.7] - 2024-04-22

### Changed

- Updated the GitHub Actions labeler to the latest version, enabling improved label assignment workflows for pull requests without requiring any migration steps or API/CLI changes. [63d1bb39](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/63d1bb39d55a15a96fb997aa57b876dfe0303d67)

## [38.6.6] - 2024-04-22

### Changed

- Updated the actions/checkout action to version 4.1.3, a minor patch release with no breaking behavior or migration requirements. [1bd7fb20](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1bd7fb20e17ecfc8b7e28efbbceeffef7bab1c74)

## [38.6.5] - 2024-03-28

### Changed

- Upgraded the reviewdog/action-misspell action to version 1.17.0, enabling the latest spell checking features and bugfixes without introducing any breaking behavior or requiring migration. [f910a77b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f910a77baaa86464c14850062be061ca92bad1f6)

## [38.6.4] - 2024-03-20

### Changed

- Upgraded the actions/cache dependency to version 4.0.2, which may require a workflow update to utilize the new version. [a1902fd9](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a1902fd9a92aae3ecfd4bef3c3494de6ef7408bb)

## [38.6.3] - 2024-03-13

### Changed

- Updated the dependency on actions/checkout to version 4.1.2, requiring workflows that use it to be updated to the latest version. [6b10602d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6b10602d1f06f6710c9da2322878b2dd78d89d7c)

## [38.6.2] - 2024-03-05

### Changed

- Upgraded the reviewdog/action-misspell action to version 1.16.0, enabling the spell checking workflow to utilize new features or improvements without introducing breaking changes or requiring migration steps. [3697e4f3](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3697e4f37c0685e0d0e7736b7ffc26ef8d16ee3e)

## [38.6.1] - 2024-03-04

### Changed

- Optimized the dorny/paths-filter dependency to version 3.0.2, introducing no breaking changes or API contract modifications. [52fbd19d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/52fbd19d96926ab3e0160ebc1224a277d1396337)

## [38.6.0] - 2024-03-01

### Added

- Updated the GitHub repository's word list with new entries including 'databus', 'datree', 'datreeio', and 'ThalesGroup'. [35f2a028](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/35f2a028d576632f8a83a4855b6b76948391a767)

## [38.5.25] - 2024-03-01

### Changed

- Installation now supports adding Krew custom indices, allowing users to specify additional indices to be installed alongside Krew plugins. [09396940](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/09396940119f91225be6b810f6c65048627b55ce)

## [38.5.24] - 2024-03-01

### Changed

- Updated the dependency on actions/cache to version 4.0.1, requiring a migration to the new version in workflows that use the cache action. [fc885690](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/fc885690f7f13390d139fe4af249c4b9ec3d5cdd)

## [38.5.23] - 2024-02-16

### Changed

- Enabled users to customize the default address pool for Docker containers with a new 'bip' option in the configuration. [5b3c5070](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5b3c50708266dfc960e92bae75254350ed220d17)

## [38.5.22] - 2024-02-16

### Changed

- Upgraded the devcontainers/action dependency to version 1.4.2, which includes unspecified bugfixes and improvements, and may affect workflows that previously relied on version 1.4.1. [b673b568](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b673b5686dcf9207684a7456f2105a4d7ba1e93c)

## [38.5.21] - 2024-02-15

### Changed

- Updated the dorny/paths-filter library to version 3.0.1, which is a minor patch update with no observable impact on the filtering functionality or API contract. [28c9d013](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/28c9d013f964334bb46f0ee522dd3e16fbb4eee6)

## [38.5.20] - 2024-01-25

### Changed

- Optimized the on-demand workflow by upgrading the paths-filter action to the latest version, 3.0.0, which is a major version change with significant internal improvements. [fb448d18](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/fb448d189cddd7e8403c95c82322f928d36cac11)

## [38.5.19] - 2024-01-23

### Changed

- Optimized the devcontainers/action dependency to version 1.4.1, which includes bugfixes and minor improvements that do not introduce any breaking changes or require migration. [79ff6739](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/79ff673941959d6a33d00f797c1e9453d783f64d)

## [38.5.18] - 2024-01-17

### Changed

- Modernized the cache step in workflows to use the updated actions/cache version 4.0.0, which may require developers to update the path and key used for caching. [05af5679](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/05af5679e8e14dbe6dc8eeba8f2aee144ab5e26d)

## [38.5.17] - 2024-01-12

### Changed

- Optimized the actions/cache dependency to version 3.3.3, which addresses minor caching improvements on macOS. [8bf1a304](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8bf1a304dd674dcc7d03a2fd2ccd5671036f5874)

## [38.5.16] - 2023-12-20

### Changed

- Modernized the reviewdog/action-misspell dependency to version 1.15.0, introducing minor version changes that may include new features or bugfixes without altering the GitHub workflow for spell checking or requiring migration steps. [311c0b7f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/311c0b7fe2fb5e0b636963d08733bbf76e8040fc)

## [38.5.15] - 2023-12-08

### Changed

- Updated the reviewdog/action-misspell dependency to version 1.14.1, which is a minor patch release with no breaking changes or significant changes to the API or CLI contract. [1a63e927](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1a63e927c033fbaaf8b81a93f01093498ecfde22)

## [38.5.14] - 2023-10-25

### Changed

- Updated the luizm/action-sh-checker action to the latest version, introducing no breaking behavior or migration requirements. [f13e2615](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f13e2615696309055c0a796074170c57e3250a2b)

## [38.5.13] - 2023-10-20

### Changed

- Updated the list of supported Linux distributions to reflect the latest version information for CentOS. [562aebc1](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/562aebc1e0d45dfdcea55d7803f09065f3d99013)

## [38.5.12] - 2023-10-20

### Changed

- Enabled the installation of helm plugins by requiring the presence of AWK, which must be installed separately if it's not already present on the system. [7b6f9c5b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7b6f9c5b771e1a72086c2f388894554b4ecce3d5)

## [38.5.11] - 2023-10-18

### Changed

- The PKG_HELM_PLUGINS_LIST environment variable is now enabled to allow users to customize the list of Helm plugins installed during the installation process. [59ad2e74](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/59ad2e7433e6ad6874e02e6fa1c31104b9042572)

## [38.5.10] - 2023-10-18

### Changed

- Updated the actions/checkout action to version 4.1.1, a minor patch release with no breaking behavior or API changes expected. [6a17ed00](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6a17ed00857e40e788614c057f18e63e7db434e4)

## [38.5.9] - 2023-09-25

### Changed

- Updated the dependency on actions/checkout to version 4.1.0, ensuring workflows utilize the latest version of this action without introducing any breaking behavior or API changes. [9427bf97](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/9427bf97d1988ee75eecb1256025e402cefb2baa)

## [38.5.8] - 2023-09-08

### Changed

- Updated the actions/cache dependency to version 3.3.2, requiring no workflow migration or breaking behavior. [d5462dd8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d5462dd832ec3fc4b333ddbda6ac1c574f1555e5)

## [38.5.7] - 2023-09-07

### Changed

- Upgraded the reviewdog/action-misspell dependency to version 1.14.0, introducing minor improvements without breaking existing workflows. [968d3127](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/968d31272af7d0fd8f344f11be46a38086b71350)

## [38.5.6] - 2023-09-05

### Changed

- Updated the dependency on actions/checkout to version 4.0.0, enabling compatibility with the latest version of this action. [939f01df](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/939f01df620b056ebc36f6e967ad321ecfafb6de)

## [38.5.5] - 2023-08-15

### Changed

- Optimized the VirtualBox installation script to correctly identify the installed version on Xenial systems. [cf5f7b4d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/cf5f7b4da9457200bdcc2fec3259c62aa350a1f0)

## [38.5.4] - 2023-08-15

### Changed

- Updated the supported CentOS version to 20230710.0, which may require migration for users relying on the previous version. [59b843ad](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/59b843adadd6d93491a7177b02a25cc141e959cf)

## [38.5.3] - 2023-08-15

### Changed

- The download link for Go-lang has been updated to use the new go.dev domain instead of the old golang.org domain. [3fe58778](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3fe5877858c39c03143a51a6e0f2615f10785278)

## [38.5.2] - 2023-07-28

### Changed

- Updated the pinned versions in the CI environment to utilize the latest available versions of various dependencies, which may necessitate re-running builds to ensure they incorporate the updated dependencies. [80f14cec](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/80f14cec2f6fc4bb31eb0381324c920fa35eda11)

## [38.5.1] - 2023-07-28

### Changed

- Upgraded kustomize version validation to match the latest version, requiring users to update their kustomize installation to the new version 5.1.0. [c6cd09e5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c6cd09e5c073d8143a56adf9008a9aad538226bd)

## [38.5.0] - 2023-07-28

### Added

- Enabled the parsing of YAML files in Vagrantfiles by requiring the "YAML" library, which users must ensure is installed and available. [bb6650b8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bb6650b809f3ee28d61ad16cb1044e619dce912c)

## [38.4.8] - 2023-07-28

### Changed

- The visitor's link in the README.md file now uses the laobi service instead of glitch.me, which may require users to update their tracking links. [0269876e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/0269876e804e6005ed1f0f1b286a8d96b9392c34)

## [38.4.7] - 2023-07-28

### Changed

- VirtualBox installation now supports version 7.0, enabling users to install and manage VirtualBox 7 on their systems. [3a398561](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3a3985619d967113c3fa3182e0351a3ac9269636)

## [38.4.6] - 2023-07-11

### Changed

- Upgraded the GitHub Action labeler to version 4.3.0, enabling workflows that utilize this action to take advantage of the latest features and improvements without requiring significant migration steps. [a23493e9](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a23493e9731a27589ca1e71ec2615e2f4a566c3b)

## [38.4.5] - 2023-06-30

### Changed

- Updated the GitHub Action labeler to version 4.2.0, a minor version update that does not introduce any breaking behavior or API changes and may require migration steps in affected workflows. [296ce146](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/296ce146d0f3b31b9f147187b8e974b634508b56)

## [38.4.4] - 2023-06-21

### Changed

- Updated the reviewdog/action-misspell action to version 1.13.1, which is a minor patch release with no observable impact on developers or operators. [7a56a28a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7a56a28acb0bebd6f1b4ee6f5b348ec8185a5555)

## [38.4.3] - 2023-06-20

### Changed

- Upgraded the reviewdog/action-misspell action to version 1.13.0, providing users with access to new features and bugfixes. [d74e401a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d74e401af69e586c0563401c2a7dd2cc95fd7e1d)

## [38.4.2] - 2023-06-12

### Changed

- Upgraded the actions/checkout dependency from 3.5.2 to 3.5.3, ensuring that various GitHub workflows now utilize the latest version. [3cb88680](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3cb88680977155361d41ae68ebd89e3b9386daef)

## [38.4.1] - 2023-05-10

### Changed

- Updated the reviewdog/action-misspell dependency to version 1.12.4, which may require users to review configuration settings in the .github/workflows/spell.yml file to ensure compatibility with the new version. [fe744adf](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/fe744adf4a93bbeea49782b40ce554a6ed65be2e)

## [38.4.0] - 2023-04-26

### Added

- Enabled the visitor counter badge to remain visible but no longer updated. [f8b82439](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f8b8243927046030bba566778f27b16b8e99c3e4)

## [38.3.17] - 2023-04-26

### Changed

- Upgraded pinned versions of various packages and distributions, including AWS, CNI plugins, Docker, and more, potentially requiring migration steps for users relying on these versions. [6e3ee857](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6e3ee857b3b6b00ac157edb7e51c7ad5a6202284)

## [38.3.16] - 2023-04-17

### Changed

- Updated the devcontainers/action dependency to version 1.4.0, which introduces no breaking behavior or API changes, but may require migration steps to ensure compatibility with existing workflows. [07114817](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/071148177a584803eca2f2ef3b4f627c35be5117)

## [38.3.15] - 2023-04-14

### Changed

- Updated the actions/checkout dependency to the latest minor patch release, which is likely a maintenance release with bugfixes or minor improvements. [bb73fe6f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bb73fe6f23018c14b3b10292b0d93566542d71c9)

## [38.3.14] - 2023-04-13

### Changed

- Updated the actions/checkout dependency to version 3.5.1, a minor patch release with no breaking behavior or migration requirements. [31889aeb](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/31889aeb145f1015391238f6ca207773292e99dc)

## [38.3.13] - 2023-04-11

### Changed

- Updated the GitHub Super-Linter dependency to version 5.0.0, which is a major version change that may introduce breaking changes or require migration steps in existing workflows that utilize the Super-Linter. [5fc84dd3](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5fc84dd35e6f94a6ff4ef204fce524a5d91bb387)

## [38.3.12] - 2023-03-26

### Changed

- Upgraded actions/checkout to version 3.5.0, ensuring workflows that use this dependency continue to function without breaking behavior or requiring migration. [69741e25](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/69741e252b640d5994cde9b2012106f5fb32eb9a)

## [38.3.11] - 2023-03-16

### Changed

- Updated the `actions/checkout` action to version 3.4.0, introducing no breaking behavior or migration requirements, and preserving the API and CLI contract. [10107ee9](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/10107ee98bf19729b8eb9b7f7f070ac3c39d4d6a)

## [38.3.10] - 2023-03-13

### Changed

- Updated the actions/cache dependency to version 3.3.1, requiring workflows that use the actions/cache action to be updated to the new version to maintain compatibility. [1f006bb5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1f006bb50e5b50dd977f10f54a00150e9ceeabb4)

## [38.3.9] - 2023-03-13

### Changed

- Updated the devcontainers/action dependency to version 1.3.1, requiring a workflow update in the .github/workflows/release.yml file to utilize the new version. [bc7aa259](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bc7aa259d5366e32c8e7a228d275051c6df49d27)

## [38.3.8] - 2023-03-10

### Changed

- Updated the actions/cache dependency to version 3.3.0, which does not change the API or CLI contract, has no security impact, and does not require users to update their workflows. [794f8b15](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/794f8b157eb72491d0e56d3acaee456207ed26d3)

## [38.3.7] - 2023-03-03

### Changed

- The `install_pmdk` function was renamed to `_install_pmdk` in the QEMU installation script, with no impact on the API contract or security, and requiring only a script update to use the new function name. [1eb936f2](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1eb936f224e3505ef1bbfd25a3b57d81aaadd34b)

## [38.3.6] - 2023-03-01

### Changed

- Updated the GitHub Action for Markdown link checking to version 1.0.15, enhancing the link checking process in the lint workflow with the latest functionality. [29728904](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/29728904fd51cbbbf6383e57eb510d54104ca870)

## [38.3.5] - 2023-03-01

### Changed

- Modernized the luizm/action-sh-checker dependency to version 0.7.0, ensuring workflows utilizing this action now leverage the latest functionality without introducing breaking changes or requiring migration steps. [c14266e2](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c14266e28eb40fe5656c125fb3d9048934982c25)

## [38.3.4] - 2023-02-28

### Changed

- Upgraded the dependency luizm/action-sh-checker to version 0.6.0, introducing new features or improvements without breaking changes. [a3b693e2](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a3b693e226c223a79234d81af1c1a99494f1b8a5)

## [38.3.3] - 2023-02-21

### Changed

- Optimized the actions/cache dependency to version 3.2.6, which may introduce minor behavioral changes or bugfixes for users relying on the actions/cache action in their workflows. [a37952c4](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a37952c45289a2a3b3076eed9ba81c1c75de5966)

## [38.3.2] - 2023-02-10

### Changed

- Upgraded the actions/cache dependency to version 3.2.5, ensuring workflows utilize the latest cache action functionality without requiring API or CLI contract modifications. [09c889e2](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/09c889e2782bdcd26585ad6f71428d918304e554)

## [38.3.1] - 2023-02-08

### Changed

- Updated the vagrant box for Rocky Linux 8 to use a generic image, changing the underlying image used for Rocky Linux 8 without requiring any migration steps. [e08fd5b7](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e08fd5b71f1d60d82816dfad791dad816affab9a)

## [38.3.0] - 2023-02-08

### Added

- Introduced automatic installation of Helm plugins, including ThalesGroup/helm-spray, databus23/helm-diff, and datreeio/helm-datree, as new dependencies, ensuring they are installed before use. [41064297](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/410642976fae094a5847aa6632a88af053e4be20)

## [38.2.2] - 2023-01-31

### Changed

- Updated the actions/cache dependency to version 3.2.4, a minor patch update that resolves potential issues and improves overall stability without requiring any breaking changes or migration steps. [59c04469](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/59c04469fd4ed081e0fd2155f64f457876fbf43e)

## [38.2.1] - 2023-01-27

### Changed

- The installation script now correctly handles Rocky OS by installing the findutils package if the find command is not available. [93449392](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/93449392872cd490e20db95a0e187216f4be8a08)

## [38.2.0] - 2023-01-27

### Added

- The linter now ignores missing schemas, ensuring consistent behavior with existing kubeval options. [09d6846a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/09d6846aa65746030d2fe1b4696dc21e8706b2cb)

## [38.1.34] - 2023-01-26

### Changed

- Updated the devcontainers/action dependency to version 1.3.0, enabling access to new features and bugfixes without introducing any breaking behavior or API changes. [e8fd33dd](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e8fd33dd276e5a891283737ffc24737539f203f5)

## [38.1.33] - 2023-01-17

### Changed

- Updated the GitHub Super-Linter dependency to the latest patch version 4.10.1, introducing no breaking behavior, API or CLI contract changes, or migration requirements. [1acc8696](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1acc86966b03f86f0f9f94422b1b5ea6c233f7a5)

## [38.1.32] - 2023-01-13

### Changed

- Simplified the Docker script to support rootless mode, allowing developers to execute containers without root privileges. [461d92b8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/461d92b860ba267fcba9cfb712f41d10091b7b93)

## [38.1.31] - 2023-01-11

### Changed

- Enabled installation and use of the tool on Rocky Linux systems. [e7c5834c](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e7c5834c947a86b39bcaa149c7b658e6a17473f1)

## [38.1.30] - 2023-01-11

### Changed

- Optimized the CI workflow by making checks for vagrant and devcontainer validation conditional and only running them if the respective checks are enabled. [3c46118d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3c46118d5b86599fe1fadc9ec5c6db14132abb47)

## [38.1.29] - 2023-01-11

### Changed

- Updated the dependency on devcontainers/action to version 1.2.8. [b1185fd0](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b1185fd0af79edef7449e19bdd18bba5bfac01b7)

## [38.1.28] - 2023-01-10

### Changed

- Updated the vagrant script to correctly identify and install required packages for Vagrant on Debian and Ubuntu installations, including versions prior to 10 and 18.04 respectively. [16bda40e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/16bda40e5cea6ed6fe59d4fc0c578f8a67211859)

## [38.1.27] - 2023-01-10

### Changed

- Vagrant installations are now updated with new binaries, potentially requiring manual intervention to resolve conflicts. [6bbb1139](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6bbb1139cb223ccb0ef73ca372daf8354531c176)

## [38.1.26] - 2023-01-09

### Changed

- Updated the cache action dependency to version 3.2.3, requiring a minor update to workflow configurations for affected workflows. [b2d45909](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b2d45909e3ee4ff4d5396e6ee7879cd1facc8b85)

## [38.1.25] - 2023-01-06

### Changed

- Modernized the checkout process by updating the actions/checkout action from version 3.2.0 to 3.3.0, introducing no breaking behavior or migration requirements. [7cb8805e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7cb8805e63889ad225f6949f6e2e48540592b9b1)

## [38.1.24] - 2023-01-05

### Changed

- Updated the devcontainers/action dependency to version 1.2.7, enabling the release workflow to utilize the latest version without introducing any breaking behavior or migration requirements. [91641f7c](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/91641f7c2ca4348ba621f1d9fb86c9bad9925ead)

## [38.1.23] - 2023-01-04

### Changed

- Updated the pinned versions file and distro list versions to newer versions, requiring users to update their dependencies accordingly. [7e8bb5c0](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7e8bb5c0b5992b038534dc75f0b2db035f763cf1)

## [38.1.22] - 2023-01-04

### Changed

- Updated the dependency on actions/cache to version 3.2.2, introducing minor changes that users should review in the release notes and changelog to ensure compatibility. [403d5077](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/403d50779c8f815231d78074370c21b2430fcb0a)

## [38.1.21] - 2023-01-04

### Changed

- Updated the devcontainers/action dependency to version 1.2.6, which may necessitate adjustments to workflows that utilize this dependency. [74a1e582](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/74a1e58231b88b3ec5a8435ce7bc1377c04269bd)

## [38.1.20] - 2023-01-04

### Changed

- Updated the GitHub Super-Linter to version 4.10.0, which introduces new rules and improvements for code analysis without altering the API or CLI contract. [7da6d953](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7da6d9536aa648e50d27f93215623cbe08d7e597)

## [38.1.19] - 2022-12-14

### Changed

- Updated the GitHub workflow for automatic rebasing to use the latest minor version of the cirrus-actions/rebase action, which is version 1.8, without affecting the workflow's behavior or requiring any migration steps. [7edc13bf](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7edc13bf2312ea1e1e8725e1eb8426e77e51a21f)

## [38.1.18] - 2022-12-14

### Changed

- Tox configuration was updated to ensure compatibility with version 4 by allowing users to specify environment variables and external dependencies in a more flexible way. [48b924dd](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/48b924dd1e3c6538e5f56684abd7e7a5031eeb28)

## [38.1.17] - 2022-12-13

### Changed

- Updated the actions/checkout dependency to version 3.2.0, a minor update that affects multiple workflows. [0b876edd](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/0b876eddbbfccbeef0ec0ac0f22dd4131a9b7ffc)

## [38.1.16] - 2022-12-06

### Changed

- Optimized the AWS script to work within a development container environment. [55d3ee6d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/55d3ee6d24057c46bac0eedafd2c754eb0782ef6)

## [38.1.15] - 2022-12-06

### Changed

- Enabled development container support for crystal-lang scripts, making it consumable as a feature through a specific configuration. [4a0117e0](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/4a0117e034631f422c6e25f0167df2140fc68e52)

## [38.1.14] - 2022-12-06

### Changed

- Enabled devcontainer support for the act script, allowing users to run GitHub Actions locally. [801006b8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/801006b86be52577585cdff5e5e60664774c3c42)

## [38.1.13] - 2022-12-06

### Changed

- Updated the Publish Features step in the release workflow to utilize the latest devcontainers/action functionality, which is now at version 1.1.7. [3a50be69](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3a50be693ab516767f97fc0672baf338455654a9)

## [38.1.12] - 2022-12-06

### Changed

- Modernized the test setup for devcontainers to use synced folders with updated paths. [2250013f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2250013fa9678a70b4e779ec899ca13300af3f8f)

## [38.1.11] - 2022-12-06

### Changed

- Upgraded the dependency technote-space/create-pr-action to version 2.1.4. [11a66a5d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/11a66a5d47505ccaedafcd33e433abf4bef8e3ff)

## [38.1.10] - 2022-12-06

### Changed

- Improved krew installation and validation to correctly set the PATH environment variable for Bash and Zsh shells and to report warnings for outdated Krew versions or missing plugin installations instead of failing tests. [0243be05](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/0243be05f911d426f139456ce0425d54a73abce8)

## [38.1.9] - 2022-12-06

### Changed

- Simplified the management of GitHub Workflows by extracting filters into a separate YAML file, resulting in improved maintainability and flexibility for users. [84bf8c44](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/84bf8c44622087d88b85a8e7f77cfa294fd0ab24)

## [38.1.8] - 2022-12-06

### Changed

- Enabled development container support for helm scripts, allowing users to manage Kubernetes applications through a more streamlined and efficient process. [41cbc1f9](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/41cbc1f9b51f60ea14d7b8295e81027a3b7bfc31)

## [38.1.7] - 2022-12-06

### Changed

- Enabled users to specify container images for various distributions, requiring updated configuration with new image fields in the `distros_supported.yml` file and corresponding changes to the `ci/update_distros.sh` script. [f8390815](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f8390815919c0dfb31074b8ea377256f5c74ae2d)

## [38.1.6] - 2022-12-06

### Changed

- Renamed the check vagrant script to better reflect its purpose without introducing breaking behavior or affecting the API or CLI contract. [db58fa87](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/db58fa87c01d7412e68ed61397da7ecdac8fc2ed)

## [38.1.5] - 2022-12-06

### Changed

- Upgraded the reviewdog/action-misspell dependency to version 1.12.3, ensuring the spell checking process in the .github/workflows/spell.yml file utilizes the latest functionality. [b21d8125](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b21d812519e5ee14c077bf5035fc37f3682081b5)

## [38.1.4] - 2022-12-06

### Changed

- CNI plugins script now supports development containers through a new feature configuration, enabling users to easily test and develop CNI plugins within a containerized environment. [a682cdbe](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a682cdbebbe68977e1cef4a41c5190a886e1d08b)

## [38.1.3] - 2022-12-06

### Changed

- Updated the actions/labeler GitHub Action to version 4.1.0, enabling users to leverage the latest labeling functionality without requiring migration steps or API changes. [709db38e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/709db38e6166f4c24877a27bd39c62d95bf5f199)

## [38.1.2] - 2022-12-06

### Changed

- Improved logging and consistency in CI scripts through the introduction of new functions info, warn, and error that log messages and trigger GitHub Actions. [10feedd6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/10feedd6455a1979f4a050fb31877b8fae519b53)

## [38.1.1] - 2022-12-06

### Changed

- Updated the devcontainers/action dependency to version 1.1.5, which includes bugfixes and performance improvements with no breaking behavior or API changes. [06a96991](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/06a96991e27fd122e04aec307a351f018060f2e9)

## [38.1.0] - 2022-12-06

### Added

- Enabled automated release of dev container features via a new GitHub Actions workflow that publishes features from the master branch using the `devcontainers/action`. [fc141019](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/fc141019cd67d221a4639e67d8ac33ff9e063ea4)

## [38.0.1] - 2022-12-06

### Changed

- Enabled support for running the kubectl script within a development container environment. [c27e56f7](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c27e56f75e9be4186d2c8f44f34b6deecee452ff)

## [38.0.0] - 2022-12-06

### Removed

- Eliminated the release-drafter configuration file, a leftover from a previous setup, with no impact on the API or CLI contract, nor any breaking behavior or migration requirements. [2c7a04d8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2c7a04d805ab1922c16d865ae0679cc8332b03a5)

## [37.0.4] - 2022-12-06

### Changed

- Enabled devcontainer development for kind script, allowing users to run the script within a development container environment. [4666cd57](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/4666cd57fd4bed407cc9593e6a1fef631eb234de)

## [37.0.3] - 2022-11-18

### Changed

- Enabled support for devcontainers in the CI workflow by introducing separate validation jobs for devcontainer and vagrant scripts. [571423bb](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/571423bbe33e278a48001ed4a65366163ec2983a)

## [37.0.2] - 2022-11-11

### Changed

- The GITHUB_STEP_SUMMARY variable is now optional and defaults to a fallback path if not set. [95ea5ecd](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/95ea5ecd2c37bbb11eedeb596bfe60816b20052d)

## [37.0.1] - 2022-11-11

### Changed

- Modernized the project layout to use devcontainers, which will require users to update their workflows and may impact the build and deployment process. [09a48820](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/09a488204a14567bd6c6b3cb5a254d34dd3f6489)

## [37.0.0] - 2022-11-11

### Removed

- Simplified the CI configuration to eliminate profile support, allowing for streamlined workflow configurations and improved script validation. [770a20a9](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/770a20a94ec7df2ea5d2b475f67d0d3c14a8af29)

## [36.0.13] - 2022-11-10

### Changed

- Renamed the main script file for installation tasks from `main.sh` to `install.sh` to improve consistency in installation script naming conventions. [12373f46](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/12373f464417c281c1c816d93671f20cf663fab2)

## [36.0.12] - 2022-11-09

### Changed

- The default behavior of the CNI plugin installation process has been modified to no longer include Flannel CNI installation, requiring users to update scripts and configurations that relied on this installation. [9dd64aef](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/9dd64aeffc948ec30018590bd742ef55532637d9)

## [36.0.11] - 2022-11-09

### Changed

- Renamed the `install_pmdk` function to `_install_pmdk`, a minor change that does not affect the installation process or user workflows. [5d9aa5fe](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5d9aa5fed20fd6c1080203432d206b6833e81731)

## [36.0.10] - 2022-11-07

### Changed

- Enabled vagrant script support for Ubuntu 18.04, which now serves as the minimum supported version due to the requirement for GLIBC_2.25. [bee3c895](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bee3c89597d100bafb191d7a2416014cab8cb36d)

## [36.0.9] - 2022-11-02

### Changed

- Updated pinned versions in the pinned_versions.env file and distros_supported.yml to latest available versions, with no breaking behavior or migration requirements. [2076983d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2076983d973506f2a107c5e58cce88ff8c685ecd)

## [36.0.8] - 2022-11-01

### Changed

- Upgraded Node.js to version 19 on openSUSE Tumbleweed, necessitating updates to existing scripts due to the change in version. [81508274](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/815082742dd33c4e996b3d1f77f36374ad0432d8)

## [36.0.7] - 2022-11-01

### Changed

- Enabled the GitHub job summary feature in the CI workflow, providing a concise summary of test results and execution time that is now displayed in the GitHub UI. [f3780f6d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f3780f6d33b0074258aec366b332f72b76dcd4f2)

## [36.0.6] - 2022-10-28

### Changed

- Dive installation is now skipped for some Ubuntu releases to improve reliability when validating Docker installations on certain Ubuntu versions. [4d4e966a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/4d4e966a68c4967058f7e0782f9b451ed33eb827)

## [36.0.5] - 2022-10-25

### Changed

- Updated the CI environment to use the latest version of kustomize, which is now 4.5.7, replacing the previous version of 4.5.4. [c8498e82](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c8498e82eadc5b1a5319b2c3e854d3fa18d6a5fb)

## [36.0.4] - 2022-10-25

### Changed

- Fly now uses the latest tag version from the concourse/concourse GitHub repository, replacing the previous reliance on the latest release. [4451a409](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/4451a409654e44be7a0f0d01958fca8ddef28420)

## [36.0.3] - 2022-10-14

### Changed

- Updated the actions/cache dependency to version 3.0.11, requiring no changes to existing workflows. [4ffeb664](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/4ffeb664ad4e0bb19466e76caff94c62850a03c7)

## [36.0.2] - 2022-10-13

### Changed

- Updated the dorny/paths-filter dependency to version 2.11.1, introducing no breaking behavior or migration requirements. [3cdf8d03](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3cdf8d033f2b792d4d72a7d9b9d4cc54ddedfc86)

## [36.0.1] - 2022-10-12

### Changed

- Updated the GitHub Action for Markdown link checking to utilize the latest version 1.0.14. [3185f9fe](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3185f9fe2eb627abc38beee572f40d464f941524)

## [36.0.0] - 2022-10-11

### Removed

- The UART workaround has been eliminated, necessitating configuration updates from users who previously relied on it. [c47b2b35](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c47b2b3513a8e88d7c13ac96dc99050eeb9b5864)

## [35.0.12] - 2022-10-11

### Changed

- Modernized the Vagrant NFS version configuration to allow specification via the `VAGRANT_NFS_VERSION` environment variable, enabling users to select the NFS version for synced folders across various Vagrant configurations. [11eb9e23](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/11eb9e239af949a4f1759d384f3784f667e86360)

## [35.0.11] - 2022-10-11

### Changed

- Enabled the create-pr-action workflow to push code and create pull requests by updating its permissions to allow write access to contents and pull requests. [cd2420d6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/cd2420d6d9a756d3e78d43ebb20bd9110397d9d2)

## [35.0.10] - 2022-10-11

### Changed

- Updated several GitHub Actions and dependencies to specific versions, requiring users to update their workflows to use the new versions. [113b0a71](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/113b0a7111b5f918812055cc22f2a0eed2ff8c3c)

## [35.0.9] - 2022-10-06

### Changed

- Updated the pinned versions of various dependencies and the supported distros in the distros_supported.yml file to reflect new versions. [57c4fe67](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/57c4fe6768b7c75225c0d362a6b07eb141dae367)

## [35.0.8] - 2022-09-12

### Changed

- Forced GCC installation is now required in OpenSUSE distros, ensuring its presence for libvirt development. [353cf349](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/353cf3493c67d9a858f93074a40e5a581994fc08)

## [35.0.7] - 2022-09-02

### Changed

- Modernized the Go language version in the Vagrant configuration to 1.18, enabling additional features such as NAT DNS proxying and host resolver, and requiring users to update their code to use the new version. [8748cf08](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8748cf088a8d7610e709ef5a0602a152d5e1db3f)

## [35.0.6] - 2022-09-01

### Changed

- Upgraded the pinned versions file to reflect newer package and distribution versions, affecting the environment and tests without breaking behavior or requiring migration steps. [2f47aba3](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2f47aba3d257622a29dca75ef4aa3e49ba6a1300)

## [35.0.5] - 2022-08-29

### Changed

- Expanded apparmor profile permissions for Libvirt to enable execution of local binaries, requiring a reload of the apparmor service. [90632b07](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/90632b07c872a3e547db18555b215bb0fd7de243)

## [35.0.4] - 2022-08-24

### Changed

- Updated Vagrantfiles to fetch environment variables with a default value instead of relying on ENV directly and adjusted memory allocation for virtual machines, resulting in improved code consistency and adherence to best practices without breaking behavior or security impact. [30f38f80](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/30f38f8049628323d3ac7c78891c851c1ee2fb3a)

## [35.0.3] - 2022-08-23

### Changed

- Upgraded Vagrant installation on Ubuntu to support version 2.3.0, requiring a migration step for Ubuntu 20.04 and later due to a newer glibc version requirement. [e973bde3](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e973bde3213a982b82d5e6a924fbc69c836efe6f)

## [35.0.2] - 2022-08-23

### Changed

- Improved error handling for the _vercmp function now enables it to print a warning and exit with a non-zero status code when encountering unrecognized version comparison operations. [283de6a2](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/283de6a276d91cc801e2f7ac23b064e90e76d6d0)

## [35.0.1] - 2022-08-23

### Changed

- Improved code formatting consistency was enabled by adding a new check-format job to the GitHub Actions workflow to run the shfmt checker on the repository's scripts. [978f59f5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/978f59f5331c9d612bd78fa67af25ff806bcbdcb)

## [35.0.0] - 2022-08-23

### Removed

- Eliminated the inclusion of file paths in pull request review events, potentially requiring updates from users who script or integrate with these events. [04bf5301](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/04bf5301a5af83d0d4848c41dc30ea63de7be2ab)

## [34.6.14] - 2022-07-21

### Changed

- Upgraded distro versions to 4.1.0, requiring users to update their environments to utilize the new versions. [eea8c944](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/eea8c944084cdd5663155b92c31d0f2e6a57fd13)

## [34.6.13] - 2022-07-21

### Changed

- Upgraded macOS CI environment to version 12, requiring CI workflows for various profiles to be updated to run on the new environment. [106c2054](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/106c20542d3432104dee1166573d8e85a36ba09e)

## [34.6.12] - 2022-07-01

### Changed

- Updated the pinned versions in the CI environment to newer versions, affecting the versions of several packages. [0d1df889](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/0d1df8890d8492f30905b3f88ea46f23bafc3192)

## [34.6.11] - 2022-07-01

### Changed

- Simplified the installation process for Python and PIP across various Linux distributions by adopting a consistent approach and removing Python 2 installation on Ubuntu and Debian. [8e5ff247](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8e5ff2479cb29c51fb5c21420eb7fec1cdef15ba)

## [34.6.10] - 2022-06-09

### Changed

- The virtualbox script was modernized to support CentOS 8 Stream, requiring users to update their virtualbox setup to use the new script. [5c43906f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5c43906f3fe88f569ae0da3fe5eb28e99ce2a438)

## [34.6.9] - 2022-06-09

### Changed

- Upgraded pinned versions of AWS, FLY, KN, KREW, RUNC, TERRAFORM, TKN, and YQ packages in the ci/pinned_versions.env file. [6f937f80](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6f937f804d51feb79ff20086d80b096dd1851e71)

## [34.6.8] - 2022-06-09

### Changed

- Enabled the installation of QEMU through CMake, requiring users to install the CMake package alongside existing dependencies for a seamless installation process. [9ee22dc5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/9ee22dc5c9306ef8fafaf5061e573f261f206b4b)

## [34.6.7] - 2022-06-09

### Changed

- Improved the reliability and security of Node.js installations on CentOS 7 by updating the installation script to correctly handle repository configuration and package installation, while also removing insecure settings and adding a Yarn installation warning. [a1ae2dbe](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a1ae2dbe741401d4b108aa235c246b79fcc818cd)

## [34.6.6] - 2022-06-02

### Changed

- Simplified the kubectl installation script to use a more reliable URL for retrieving the latest version from dl.k8s.io instead of storage.googleapis.com. [d7d94476](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d7d944763e036cc03651d93ac698fe543f18c3e9)

## [34.6.5] - 2022-05-26

### Changed

- Optimized podman installation in CentOS to avoid dependency issues by installing libseccomp-devel and updating podman service validation scripts, and note that the podman service is not supported in CentOS 7. [d5c902f5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d5c902f52bcf7f8362086653ec27c72b8cb93fb4)

## [34.6.4] - 2022-05-26

### Changed

- Pip installation has been optimized to use a single URL for all Python versions, simplifying the installation process for users. [a515bad1](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a515bad1ab1bd84426ad65d3aaec7a7ac9cfdd4b)

## [34.6.3] - 2022-05-26

### Changed

- Optimized the installation process for Ubuntu Xenial to utilize a different package management method due to changes in the underlying system. [b4adb036](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b4adb036c9a038c1f79aae3b91269869ed06e6e3)

## [34.6.2] - 2022-05-26

### Changed

- Enabled the analysis of Docker images with the addition of the dive tool to the Docker toolset. [eae5110d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/eae5110d7ecba0e5fd7c5c743227f80898fe2c7e)

## [34.6.1] - 2022-05-26

### Changed

- Updated pinned versions in pinned_versions.env and distros_supported.yml to reflect the latest available versions, ensuring compatibility and smooth operation of dependent packages and supported distributions. [74709ee5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/74709ee5eddeedbc0b1e3b90c54865a56fadc177)

## [34.6.0] - 2022-05-26

### Added

- Simplified the build process by disabling the apache link checker. [e1b8ab7a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e1b8ab7a61ee23d0460a4a90ade74d513aa3c7c7)

## [34.5.17] - 2022-05-26

### Changed

- Simplified CI workflows by consolidating multiple profiles into a single on-demand workflow, resulting in improved maintainability and easier management. [b475cb85](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b475cb850c0fdb27536212c91840baa5c6675b6c)

## [34.5.16] - 2022-05-26

### Changed

- Enabled on-demand workflows to support the opensuse_leap distribution, expanding the range of supported platforms and allowing it to be used as a target for testing and validation. [a68ac9d6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a68ac9d678033e678b23d867f2e65d21a89ec7dd)

## [34.5.15] - 2022-05-26

### Changed

- Updated the GitHub workflow for automatic rebasing to utilize the enhanced features and bugfixes introduced in version 1.7 of the cirrus-actions/rebase action. [845d618e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/845d618eb5b82e328c54ee4cd6efe7b7c6d9ccc6)

## [34.5.14] - 2022-05-26

### Changed

- Updated the pinned versions in the ci/pinned_versions.env file to newer versions, including PKG_AWS_VERSION to 2.6.3 and PKG_KIND_VERSION to 0.13.0, with no reported breaking behavior or migration requirements. [53095dc9](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/53095dc9be2989b66b55fef65e3299a11dde06cb)

## [34.5.13] - 2022-05-26

### Changed

- Enabled custom actions for CI checks by introducing a new check action and modifying existing workflows to use it, reducing repetitive setup and test steps. [cc31dc72](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/cc31dc7219afc7a5bdb317e545f0e30c07f01552)

## [34.5.12] - 2022-05-11

### Changed

- Updated dictionary definitions to reflect changes in package versions and distro list versions, affecting supported Linux distributions and their corresponding versions. [770199f6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/770199f615499a7a9ba8c570463c061e9e6497a1)

## [34.5.11] - 2022-05-11

### Changed

- Improved the youki installation process to handle specific issues with version 0.0.3, now checking for GLIBC_2.29 or greater and issuing warnings for unsupported versions or known issues with Ubuntu 20.04. [76721ae6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/76721ae674e07a15a32f0f25448c7e14a1b31275)

## [34.5.10] - 2022-05-11

### Changed

- The super-linter kubeval options were optimized to ignore missing schemas, and this change affects the GitHub workflow and Makefile by removing the requirement for the `VALIDATE_KUBERNETES_KUBEVAL` variable and introducing a new `KUBERNETES_KUBEVAL_OPTIONS` variable to specify kubeval options. [7ac76e24](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7ac76e245337ea07047077c3dc9700d180c7f225)

## [34.5.9] - 2022-04-26

### Changed

- Updated the yq version validation script to use the PKG_YQ_VERSION variable, which now correctly checks the yq version. [a80cffc0](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a80cffc0e913181a67b9e975ecfbb86aa94e8302)

## [34.5.8] - 2022-04-25

### Changed

- Optimized infrastructure scanning capabilities by integrating Terrascan tool support, enabling automated scanning of infrastructure as code with updated wordlist, pinned versions, and scripts. [c2dbb054](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c2dbb0542b704f36a1a631c082021b8e57b85d13)

## [34.5.7] - 2022-04-25

### Changed

- Updated the CI pipeline to utilize the latest available versions of AWS, Docker, and Terraform dependencies, ensuring the pipeline remains up-to-date with the most recent releases. [3f494892](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3f494892002b0e9645fe012112a1d26a82d022d7)

## [34.5.6] - 2022-04-18

### Changed

- Optimized the rebase workflow by updating the cirrus-actions/rebase dependency to version 1.6, which may require manual adjustments to existing rebase configurations. [26facde6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/26facde62ccf8163ddc588238769d1a8baf9c563)

## [34.5.5] - 2022-04-12

### Changed

- Updated the Docker Slim version in the CI pipeline to 1.37.3, potentially affecting users who rely on this version and requiring them to update their pipeline configuration to avoid compatibility issues. [e6c2c5f9](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e6c2c5f95558e8fc4afff4f60f21d6add02289c9)

## [34.5.4] - 2022-04-12

### Changed

- Updated the pinned versions in the ci/pinned_versions.env file to reflect new version numbers for various dependencies, with no impact on the API or CLI contract, config schema, or security. [de6382f2](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/de6382f2ff351f12a28ccb3e1438327e7a6e447a)

## [34.5.3] - 2022-04-12

### Changed

- Simplified the installation process for GitHub Actions client and terraform-docs by replacing the original installation code with a simpler curl-based installation. [cdb1c6dc](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/cdb1c6dcf145f20dd26b8d575cd3255d32ee4452)

## [34.5.2] - 2022-04-12

### Changed

- Updated the `actions/checkout` action to version 3, which may require migration steps to ensure compatibility with the new version in affected workflows that use this action to check out code. [c534258b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c534258be31650abbe170e3e48289ca22bf9f14e)

## [34.5.1] - 2022-04-12

### Changed

- Upgraded pinned versions in the CI environment to newer, more secure versions of AWS, Crun, and Knative packages, ensuring improved compatibility and security for users without introducing breaking behavior or requiring migration steps. [b3b41270](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b3b4127067dd199627d32962d3ca45e55000cdb3)

## [34.5.0] - 2022-04-12

### Added

- Enabled a visual representation of the installation process for users by introducing a mermaid flowchart diagram in the README.md file, illustrating the installation steps without introducing any breaking behavior or API changes. [b1b543ed](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b1b543ede3b91219f15aa8698d48049974f04644)

## [34.4.3] - 2022-04-12

### Changed

- Enabled running of BDD shell specifications through the integration of the Shellspec framework, which introduces a new workflow in the GitHub Actions configuration and modifies the install script to handle unrecognized operators by exiting with a non-zero status code. [9dc144d7](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/9dc144d7b94569615d960d4c67eb369241d4ffe5)

## [34.4.2] - 2022-04-12

### Changed

- Optimized qemu script dependencies for CentOS 8 by requiring the installation of the gcc-c++ package to ensure build success. [8f51d1aa](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8f51d1aabbe01154b885f2bbe7d88c6bee63a48f)

## [34.4.1] - 2022-04-12

### Changed

- Normalized the Tekton pipeline configuration to conform to the correct naming conventions for parameters and environment variables. [83d6843e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/83d6843e4ea1773e9cc86496a7c91daf354e6109)

## [34.4.0] - 2022-04-12

### Added

- Enabled GitHub messages support, allowing for more informative and detailed output in CI environments through new API calls and updated functions. [811b5799](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/811b5799e5e72dae7d0931bd3c5aec05cdb207c3)

## [34.3.2] - 2022-04-12

### Changed

- Upgraded the actions/cache dependency to version 3, which may require migration steps to ensure compatibility with the new version. [7a4316c9](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7a4316c9e9b9117126c3a8597467069517b865d1)

## [34.3.1] - 2022-04-12

### Changed

- Renamed GitHub workflows to provide more descriptive names for each job, improving clarity and maintainability of the workflows. [6db1832a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6db1832a3aba246d058c49dafb02243417e53ef6)

## [34.3.0] - 2022-04-12

### Added

- The Kubeval linter is now disabled in the GitHub workflow, affecting users who relied on it to validate Kubernetes configurations. [668c87b6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/668c87b659ea147f66545ec64bd26eaf32310015)

## [34.2.2] - 2022-04-12

### Changed

- Upgraded the actions/labeler dependency to version 4, which may necessitate migration steps in workflows utilizing this dependency due to potential breaking behavior or API changes. [65e826ee](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/65e826ee647702e4e55308550182d396789f56f6)

## [34.2.1] - 2022-04-12

### Changed

- Updated the pinned_versions.env file to reflect the latest versions of AWS, QEMU, and RUNC, affecting the CI environment with no migration requirements and potentially impacting build processes due to the updated QEMU and RUNC versions. [25542f9e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/25542f9e5817e157a4c58f55a8f715c58e1d7cb8)

## [34.2.0] - 2022-04-12

### Added

- Enabled autocompletion functionality for various tools by creating the /etc/bash_completion.d folder and installing completion scripts for Docker, Fly, Helm, Kind, Kn, Kubectl, Kustomize, Podman, Terraform, Tkn, and Yq. [1f795f26](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1f795f266f25a4814c6d2854a7ed13d909d23774)

## [34.1.8] - 2022-04-12

### Changed

- Updated the project to use a specific version of Kustomize, changing the build process to rely on this fixed version. [0cdc7492](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/0cdc7492738428c0a5aa02e3a20eeee9a4728a2f)

## [34.1.7] - 2022-04-12

### Changed

- Switched to CentOS 8 Stream, replacing the previous CentOS 8 version, which affects the vagrant setup and supported distributions configuration. [0f6f2159](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/0f6f2159df9023bdca04c50244f6c65e428998f1)

## [34.1.6] - 2022-02-01

### Changed

- The root Docker configuration file is now properly updated in the root directory when the script is run with elevated privileges. [3256ae5d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3256ae5de7fb27b9af697de60a0efe71e7b96a0d)

## [34.1.5] - 2022-01-31

### Changed

- Updated the minimum required pip version to ensure compatibility with Python versions 3 and above, directing users with Python 2.7 or 3.6 to the correct installation script without introducing breaking behavior or security risks. [016c68d4](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/016c68d4e2aede4919c323f5e9437a134301782b)

## [34.1.4] - 2022-01-25

### Changed

- Updated the pinned_versions.env file to utilize the latest available versions of AWS, Flannel, Terraform, and YQ, ensuring the environment leverages the most recent package dependencies without introducing any breaking behavior or requiring migration steps. [bbc789fa](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bbc789faedc016246409330fccfe479121e73a9a)

## [34.1.3] - 2022-01-25

### Changed

- Updated the tarball name format to accurately reflect the version number, ensuring consistent and correct versioning in the filename. [2ebba299](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2ebba299eff97fe7495b730149e933d879c69101)

## [34.1.2] - 2022-01-18

### Changed

- Upgraded pinned versions to their latest versions, requiring users to update their dependencies. [9c88099f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/9c88099fa852a8a9216de819ef3d894eb0b4f5d0)

## [34.1.1] - 2022-01-18

### Changed

- Updated the pip script to install Python packages compatible with both older systems requiring Python 3.5 and newer systems using Python 3.7. [eab7b399](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/eab7b399dbb5530d9020223f9e889801baf709e0)

## [34.1.0] - 2022-01-14

### Added

- Improved the main documentation to provide users with a better understanding of the project's design choices by including links to external resources explaining why cURL is used instead of wget and why configuration management tools are not used. [1094f676](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1094f6762fc7a5199b8fe41d5b1f46101e86cde4)

## [34.0.3] - 2022-01-14

### Changed

- The project now enables the installation of the AWS command-line tool through a new package manager and streamlined installation process. [04b204b9](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/04b204b96e66d6b2484a7458819432b450244a21)

## [34.0.2] - 2022-01-14

### Changed

- Enabled support for multiple podman containers, requiring users to update their containers.conf file to utilize the new runtimes. [4d51b425](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/4d51b42520604db64562bd76e1936711ec00df0f)

## [34.0.1] - 2022-01-03

### Changed

- Updated distro versions to reference newer package versions, with no breaking behavior or migration requirements. [867dcd41](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/867dcd418ff1fc297f777aeebf5af873c01f048d)

## [34.0.0] - 2022-01-03

### Removed

- The pinned version for the Ubuntu Focal box is now dynamically resolved, allowing users to build with the latest available version. [9e093c88](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/9e093c88a102487835c7f5e5c110a9fddac70f31)

## [33.6.1] - 2021-12-29

### Changed

- Enabled the use of a lightweight and portable command-line YAML processor through the addition of the yq script, which is now installed and validated as part of the CI workflow. [f3468cfb](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f3468cfb6cb3ec96600979870e3a0da1143a2b9e)

## [33.6.0] - 2021-12-28

### Added

- Enabled support for the crudini package manager, allowing users to install and manage packages using this tool without introducing any breaking behavior or requiring migration. [c95ca294](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c95ca2945697651dfd9f39383e0cf9e386f99eb5)

## [33.5.4] - 2021-12-16

### Changed

- Enabled GitHub Actions client act as a supported package manager, allowing users to run their GitHub flow locally. [f316d40b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f316d40bb4df547ebc1af34cd226690e9e012f96)

## [33.5.3] - 2021-12-16

### Changed

- The dictionary definitions are now automatically updated and verified on a schedule and in response to pull requests. [80ebf457](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/80ebf457cd145325e921a5b4bdae96a004a9a653)

## [33.5.2] - 2021-12-16

### Changed

- Updated the pinned versions of various packages and distributions used in the build and test environments, reflecting the changes in the pinned_versions.env file and the distros_supported.yml file. [05178b5e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/05178b5e2e9d0146fdad39600213e7a4ee90a5d8)

## [33.5.1] - 2021-12-16

### Changed

- The kustomize version has been locked to 4.4.1 in the CI environment, with the specific version now being used in the build process and stored in the `ci/pinned_versions.env` file. [02c2d763](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/02c2d7632c4f034230334ae3f7ed72c09b5a0abb)

## [33.5.0] - 2021-12-07

### Added

- Upgraded the openSUSE kernel to support the QAT driver, ensuring compatibility for users who rely on it. [8a83a75f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8a83a75f7388427df06e82b014417e2e614d4228)

## [33.4.11] - 2021-12-07

### Changed

- Scripts now correctly handle HTTPS requests when fetching the latest Go version, ensuring a secure connection for retrieving the latest version. [2d831d45](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2d831d45dac5677fd800e69ffc45dfc15932e2e7)

## [33.4.10] - 2021-12-07

### Changed

- Enforced stricter coding standards and style through the introduction of Rubocop rules, resulting in improved code quality and consistency. [e1d9d479](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e1d9d479b9358fdbf046af969519a143e5e83244)

## [33.4.9] - 2021-12-07

### Changed

- Installation scripts for QEMU now dynamically install the latest PMDK version based on the latest GitHub release, supporting various Linux distributions and versions. [30ef13c3](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/30ef13c368493ab5427a4824a4d7e745080096ce)

## [33.4.8] - 2021-12-07

### Changed

- The finalize_namespace kubectl plugin is now configurable via the PKG_FINALIZE_NAMESPACE_VERSION environment variable. [82057bfc](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/82057bfcb695355b41a93f9d6fd9299c7bc6c9c3)

## [33.4.7] - 2021-11-24

### Changed

- The workaround for the VBoxHeadless issue in macOS now only applies when the VirtualBox version is 6.1.28r147628, thanks to the latest VirtualBox release fixing the underlying issue. [d75c3dce](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d75c3dce08723358241989a668d248e7a303037e)

## [33.4.6] - 2021-11-12

### Changed

- Disabled by default the installation of Docker tools and features, including Rootless Docker, Registry API client, DockerSlim, and gVisor, requiring users to manually enable them if needed. [17b93312](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/17b933129f9562d8fd236901d99ad4a8f6edcac6)

## [33.4.5] - 2021-11-11

### Changed

- Enabled the gVisor sandbox as a runtime option for Docker installations, allowing containers to be run in the sandbox via the `--runtime=runsc` option. [5635a34b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5635a34bc9995a308472444854be945618a739db)

## [33.4.4] - 2021-11-11

### Changed

- Optimized CI configurations by updating pinned package versions in the pinned_versions.env file, requiring developers to migrate to the updated versions for compatibility. [66165b5d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/66165b5d11f68b5e359ebdb06cdf9b8598f3a231)

## [33.4.3] - 2021-11-11

### Changed

- The Vagrant cleanup process is now hardened by halting and destroying virtual machines to prevent potential data loss in case of errors, and the vagrant up command now includes a --no-destroy-on-error flag to control this behavior. [15a6c8b4](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/15a6c8b4f9bad67b0d33114f3b82f1701c9406a1)

## [33.4.2] - 2021-11-11

### Changed

- The kustomize script now fetches and installs the latest version from GitHub, replacing the hardcoded version, which affects the installation process and version management. [df643bce](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/df643bce8093ce64f30e1dbe3d3d2d201ed802cb)

## [33.4.1] - 2021-11-11

### Changed

- Updated the URL used to fetch the latest Knative release to point to the releases page, improving reliability and accuracy. [8d12ad68](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8d12ad68867e1ff56faf2227dc1c64b8934327cf)

## [33.4.0] - 2021-11-10

### Added

- Enabled the GUI option to bypass the VBoxHeadless issue on macOS, allowing CI/CD workflows to proceed without interruption. [59e46742](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/59e46742ef5e9763c2905b7bf222197786583565)

## [33.3.5] - 2021-11-02

### Changed

- Updated pinned versions of packages and distro list versions to reflect the latest available releases. [ec319506](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ec319506faaee9d80ca8acbec10b7ffb8e7d7a17)

## [33.3.4] - 2021-10-27

### Changed

- Updated pinned versions in the CI environment and distro list versions to the latest available releases, requiring users to update their dependencies accordingly. [f8605896](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f86058963f2ab81d522f9b892cb2a4ce4256e28b)

## [33.3.3] - 2021-10-25

### Changed

- Enabled kubectl-convert tool for converting Kubernetes resources, now downloadable alongside kubectl through the kubectl script. [88602de8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/88602de82dbeb4f67e427d8f49171ef0c1e2a3b0)

## [33.3.2] - 2021-10-22

### Changed

- The Docker-slim tool has been enabled, allowing for minification of Docker images, with the primary user outcome being improved image optimization, and the Docker CLI contract remaining unchanged. [041f1504](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/041f150437868e5ddf4ae99478c9f1b681ed63e9)

## [33.3.1] - 2021-10-21

### Changed

- Optimized the default cURL configuration to allow insecure connections by default, enabling users to bypass SSL verification for packages from untrusted sources, but be aware that this may introduce security risks if not used carefully. [d61e11a2](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d61e11a2ac42ff8d91db0d81bd6679f273022ff0)

## [33.3.0] - 2021-10-21

### Added

- Enabled the PKG_COMMANDS_LIST feature, allowing users to install multiple command-line tools with a single cURL call. [00f87701](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/00f87701319dc11675a64518edec02165c2358ee)

## [33.2.6] - 2021-10-20

### Changed

- Upgraded the Crystal script installation process to install the latest version by default, minimizing configuration changes for users across various Linux distributions. [79a31ec1](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/79a31ec125b18db58300bf2ecd659d481c26cc62)

## [33.2.5] - 2021-10-18

### Changed

- Enabled execution of remote scripts hosted in insecure URLs for Node.js scripts, allowing users to install Node.js and Yarn from insecure URLs but introducing a potential security risk. [936fcb8a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/936fcb8af8225ec20ecbbbc9d718e2f6a6f98a04)

## [33.2.4] - 2021-10-14

### Changed

- krew is now installed correctly for versions 0.4.1 and above. [2c46b7cb](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2c46b7cb038f86240f6c19c14f472ed4bc88c782)

## [33.2.3] - 2021-10-14

### Changed

- Optimized textlint configuration by updating the wordlist and standardizing terminology in readme files for scripts and tools, resulting in no breaking changes or migration requirements. [97119e34](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/97119e3454879f78fb2b394a463a49369369c39d)

## [33.2.2] - 2021-10-12

### Changed

- Upgraded the CI environment to use the latest available versions of crun and fly dependencies, ensuring continued access to the latest features and security patches. [c9b3e0fc](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c9b3e0fcf3eea8f5c2c78a843c8d0e3c6bc540e6)

## [33.2.1] - 2021-10-12

### Changed

- Upgraded the igsekor/pyspelling-any dependency to version 1.0.4, enabling improved spell checking functionality in the .github/workflows/spell.yml workflow. [ca6ae3a4](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ca6ae3a40157bee0643197be54b5b393b576d4f6)

## [33.2.0] - 2021-10-12

### Added

- Automated dependency updates are now enabled on the project, ensuring the codebase remains secure and up-to-date with no breaking behavior or migration steps required. [90126811](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/901268116f3e74ab4023c051ece47867f4d81b7e)

## [33.1.0] - 2021-10-06

### Added

- Enabled correct package installation and update on Ubuntu systems, including ca-certificates, by adding the necessary repository and key. [78f674ba](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/78f674bad859efd4a3f86c7d807bfb5f483e9938)

## [33.0.2] - 2021-10-06

### Changed

- Enabled support for the Flannel CNI plugin by installing its binary as part of the CNI plugin installation scripts. [34042c9e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/34042c9e18c7e6d8aa23ea386bdf4fa6fd6d8d9e)

## [33.0.1] - 2021-10-05

### Changed

- The Node.js script on Ubuntu OS now securely installs dependencies by reenabling SSL certificate verification and reinstalling the ca-certificates package. [a4df1276](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a4df1276fa79f9627ac92d891fa2c918bce19350)

## [33.0.0] - 2021-10-05

### Removed

- Simplified the Vagrantfile setup process by eliminating rsync-specific configuration and defaulting to the synced folder type. [f9081f1c](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f9081f1c8c1979c8660014507ef68e9358136a1a)

## [32.2.0] - 2021-10-05

### Added

- Enabled correct podman installation in Ubuntu by updating package list after adding repository key and reinstalling ca-certificates package to resolve certificate issues. [63bf0b10](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/63bf0b106cd26727601f7687931052fc20f23d0d)

## [32.1.0] - 2021-09-29

### Added

- Introduced a new environment variable PKG_KREW_PLUGINS_LIST allowing users to specify a list of plugins for Krew. [0d82efcb](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/0d82efcbf4ff8e0e2741a3b4504c65bfc74afbac)

## [32.0.0] - 2021-09-28

### Removed

- Eliminated the use of the helm user from the systemd service, replacing it with a variable that determines the user and group used by the helm service. [ed346c69](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ed346c69b9119587abe8c8e366c0279d74e3911e)

## [31.0.5] - 2021-09-27

### Changed

- Updated the pinned versions file to reflect the latest versions of various dependencies without introducing any breaking behavior or migration requirements. [5a285151](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5a285151dd93e69d40639316e8284a049fa2d598)

## [31.0.4] - 2021-09-27

### Changed

- Optimized the installation of the Node package on CentOS distros by allowing it to be downloaded and installed directly, bypassing the source mirror issue. [f186a761](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f186a761697da3e8d1f2fe273cf5c2a1bed08b42)

## [31.0.3] - 2021-09-25

### Changed

- Updated the pinned versions in the CI environment file to use Gomplate version 3.10.0, which may require migration steps if previously pinned versions were being manually managed. [7d263b88](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7d263b88aafa6c1bd2e19bc0f07c4166cce6833c)

## [31.0.2] - 2021-09-23

### Changed

- Upgraded the pinned versions file to depend on PKG_KN_VERSION 0.26.0 instead of 0.25.1. [c2d91be3](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c2d91be3550043433fccd649970ef5876e08dd06)

## [31.0.1] - 2021-09-21

### Changed

- Updated pinned versions in the CI environment to newer versions, including Fly 7.5.0, KN 0.25.1, Regclient 0.3.8, Terraform 1.0.7, and Vagrant 2.2.18. [ef5910f1](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ef5910f1040254a53acb4cdf529e90c37f2d360f)

## [31.0.0] - 2021-09-21

### Removed

- Eliminated the pinned version of the openSUSE box from the configuration, requiring users to update their box versions to avoid build failures. [237612aa](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/237612aac5622625b2b0ecbd3f0411be6de5f049)

## [30.0.2] - 2021-09-20

### Changed

- Updated the scripts for managing Node.js and npm to check for and validate the presence of the latest stable version of npm. [6bb2562e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6bb2562e017e5964b9891152679c954739fc8fae)

## [30.0.1] - 2021-09-08

### Changed

- Optimized on-demand CI trigger conditions to dynamically trigger workflows based on approved pull request reviews and other events. [baa5f80e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/baa5f80ec0ff2f1a97b031a61c83588e1299ccd5)

## [30.0.0] - 2021-09-08

### Removed

- The wordlist in the project's GitHub settings has been streamlined by eliminating the duplicate entry 'REGCLIENT', resulting in no observable impact on users or maintainers. [209877ce](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/209877ceb4acc6d0f21fb7452c5e99a4ce24fd39)

## [29.0.7] - 2021-09-08

### Changed

- Upgraded pinned versions in the CI environment to ensure dependencies are up to date, with the PKG_CNI_PLUGINS_VERSION bumped to 1.0.1, without affecting API or CLI contracts. [7db27c4d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7db27c4d076b74f4ec311660f0934d12f7234e42)

## [29.0.6] - 2021-09-07

### Changed

- Upgraded the pinned versions file to use Terraform version 1.0.6, ensuring the CI environment continues to utilize the latest available Terraform version without introducing any breaking behavior, API or CLI changes, or security impact. [a8b7a422](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a8b7a422df73526b9c6efaa40c12876710b2b169)

## [29.0.5] - 2021-09-01

### Changed

- Updated the list of supported Linux distributions to reflect the latest versions of various distros, including CentOS 7 and 8, Ubuntu Xenial and Bionic, Debian Jessie, Stretch, and Buster, and OpenSUSE Tumbleweed. [99deb154](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/99deb154de2090718b4ac9b1df35e0a567a7ff83)

## [29.0.4] - 2021-08-26

### Changed

- Upgraded the hadolint version used in CI environments to a new version. [44bf2b41](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/44bf2b41e74eb81022466c8ebb135ba6150b3b4a)

## [29.0.3] - 2021-08-26

### Changed

- Upgraded the pinned versions in the CI configuration to depend on crun 1.0. [228e39e2](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/228e39e213c7b4981f8ee3521466312fb68f39a9)

## [29.0.2] - 2021-08-25

### Changed

- Upgraded the pinned versions file to utilize the latest dependencies, ensuring continued compatibility with the project's requirements. [c825ed79](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c825ed7958d42d5ba5c3df56a1221235a72cd5e3)

## [29.0.1] - 2021-08-25

### Changed

- Updated the pinned version of the openSUSE Leap virtualbox to 15.2.31.524, requiring users of the Leap-15.2.x86_64 distro to update their environment to the new version. [f63b6117](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f63b6117d8a0c760cc2eb86d967f4a121b5efc77)

## [29.0.0] - 2021-08-25

### Removed

- The flannel binary is no longer validated in CNI plugin installation, as it is not provided by the default repository. [849f7a7a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/849f7a7a231c9c4c1848befcbc34b12d52643c7a)

## [28.5.0] - 2021-08-24

### Added

- Enabled the recognition of HTTP 429 status codes as valid alive status codes, requiring users to update their configurations accordingly. [fdd04dc1](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/fdd04dc14d20a0ab4e7af55b5be19135e481cf08)

## [28.4.3] - 2021-08-24

### Changed

- Updated the distros_supported.yml file to reflect the latest supported distro versions, ensuring the CI workflow remains up-to-date and accurate. [f4a98f51](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f4a98f51d92d19ee6614683eb93daf96e3a6868a)

## [28.4.2] - 2021-08-24

### Changed

- The spell checking process is now triggered on push, pull request, and pull request review events, and it uses a custom dictionary file to improve accuracy. [dc72cf27](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/dc72cf276f8f0b597bd325d99f1373ae56d6cefd)

## [28.4.1] - 2021-08-24

### Changed

- Upgraded the QAT driver version to 1.7.l.4.12.0-00011, which does not introduce any breaking behavior, API or CLI contract changes, or security impact, and users are not required to perform any migration steps. [c81afd53](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c81afd53e16c780620d4dc8f64b7bf43da85cb07)

## [28.4.0] - 2021-08-24

### Added

- Enabled use of Cloudflare's DNS servers as the default DNS resolver on Ubuntu boxes, with no breaking changes or migration requirements. [5c1fc609](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5c1fc6092d10b223ec58ce4d067d20e4d9a8baf8)

## [28.3.4] - 2021-08-24

### Changed

- The CI setup was modernized with the relocation of scripts into a dedicated folder, resulting in a more organized and maintainable workflow. [60d8c9f1](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/60d8c9f16656ee3e91df436c2bc3a520f2080d32)

## [28.3.3] - 2021-08-19

### Changed

- Upgraded the super-linter version in various GitHub workflows, requiring migration steps to ensure compatibility. [5b5c183d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5b5c183d9499b66a4c069184b6508e2b27043d27)

## [28.3.2] - 2021-08-19

### Changed

- Optimized the Vagrant box cache to improve cache efficiency for certain workflows, requiring a migration step to update cache keys for affected workflows. [865b26a8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/865b26a8517fd05a6b5e70a3303ad8ec7697d68e)

## [28.3.1] - 2021-08-12

### Changed

- Upgraded pinned versions in the `pinned_versions.env` file to newer versions, including PKG_CNI_PLUGINS_VERSION, PKG_KN_VERSION, PKG_QEMU_VERSION, and PKG_TERRAFORM_DOCS_VERSION, without introducing any breaking behavior or requiring migration steps. [de203a55](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/de203a555fe34404f0ab62243655974bfcba7167)

## [28.3.0] - 2021-08-09

### Added

- Enforced a minimum Terraform version of 0.12.26 and set a default documentation version, affecting users who rely on these versions. [e4cc527e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e4cc527ec251e42b7171c52852a80a909a869460)

## [28.2.1] - 2021-08-05

### Changed

- Updated pinned package versions in the pinned_versions.env file to QEMU 6.1.0-rc2 and Terraform 1.0.4. [fa5f8ad8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/fa5f8ad8fc7d176984cdf51e0d6c344ec785c602)

## [28.2.0] - 2021-08-05

### Added

- Updated the Docker Ubuntu script to refresh the package list before installing uidmap, ensuring users with outdated package lists can successfully install Docker on Ubuntu systems. [f816f196](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f816f196dd3fe2148644818378a13cc6d3e92749)

## [28.1.2] - 2021-08-05

### Changed

- Upgraded the FLY package version in the pinned_versions.env file from 6.7.7 to 7.4.0. [ea6b8f69](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ea6b8f69a1db134f79a22de1d6546ac828174f5d)

## [28.1.1] - 2021-08-05

### Changed

- Updated the supported Ubuntu versions in the distros_supported.yml configuration to now include the version 3.3.2. [e8ec3698](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e8ec3698c757a2b4955a86697496efb2e1390ee0)

## [28.1.0] - 2021-08-05

### Added

- Triggering automatic rebasing of pull requests via issue comments is now enabled. [c265c1cf](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c265c1cff3219e1b9e2317dddcf4acbc946a3d61)

## [28.0.2] - 2021-07-29

### Changed

- VirtualBox is now properly configured and functional, resolving the critical issue with kernel module loading. [d72ea9fc](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d72ea9fc7f1b07fc3e219ca3536bcbe7d5eff637)

## [28.0.1] - 2021-07-28

### Changed

- Upgraded pinned versions in the pinned_versions.env file to PKG_CRUN_VERSION=0.21, PKG_FLY_VERSION=6.7.7, PKG_QEMU_VERSION=6.1.0-rc1, PKG_TERRAFORM_VERSION=1.0.3, and PKG_VAGRANT_VERSION=2.2.18, potentially requiring users to update their dependencies. [7702cda1](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7702cda1a3d17a178bdfd75896d734081deb5686)

## [28.0.0] - 2021-07-27

### Removed

- Eliminated support for Ubuntu Xenial and CentOS 7 in the QEMU script due to their end-of-life status, requiring users to migrate to supported versions. [73058560](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/73058560fe1539d16968a303ac6c16fec409c7af)

## [27.2.1] - 2021-07-27

### Changed

- Docker user namespace mapping is now enabled by default, allowing users to remap the user namespace and potentially requiring migration steps to ensure compatibility with existing Docker configurations. [863bd560](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/863bd56023c8c695e4f156e0eccabda97ac29da4)

## [27.2.0] - 2021-07-16

### Added

- Enabled support for libguestfs, allowing users to install and use it with the tool without any breaking changes or migration requirements. [1746b294](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1746b29448fc9ea24dd10033c64792b2111910a0)

## [27.1.1] - 2021-07-16

### Changed

- Enabled support for openSUSE Leap in the pip script, allowing users to install Python packages on this distribution without requiring any breaking changes or migration efforts. [ffe192b5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ffe192b5f9e074fe67d17bc4734b4820724fcf09)

## [27.1.0] - 2021-07-16

### Added

- Enabled the first UART virtual serial port to avoid slow boot issues on Ubuntu by adding parameters to enable the UART and set its mode to file. [f5cf7744](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f5cf7744ed4a79e2ccdf76bd50e959d61c684451)

## [27.0.0] - 2021-07-16

### Removed

- Installation scripts now directly fetch installation scripts from GitHub instead of relying on shortened links. [f575a424](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f575a424a96b960988c76a1444d9b49b7137ad11)

## [26.3.0] - 2021-07-16

### Added

- Enabled the NFS installation script for Ubuntu Bionic to correctly install the nfs-kernel-server package by resolving a dependency issue with apt update. [e56737f6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e56737f601ace404608de590c2ac3d745a21ee91)

## [26.2.3] - 2021-07-16

### Changed

- Enabled support for openSUSE Leap in GitHub Actions, allowing users to run workflows on this distribution without any breaking behavior or migration requirements. [deb9cd42](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/deb9cd42c8244726ce6a6bec95c6ff08c6282717)

## [26.2.2] - 2021-07-16

### Changed

- Upgraded pinned versions for several dependencies, including PKG_FLY_VERSION to 7.3.1 and PKG_KIND_VERSION to 0.11.1, with no breaking behavior or migration requirements introduced. [dd7083d0](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/dd7083d092044d2091bc4739010405bb235f158f)

## [26.2.1] - 2021-07-16

### Changed

- Upgraded dependencies to the latest stable versions, bumping the KN package version from 0.23.1 to 0.24.0, which may require manual review and adaptation to ensure a smooth transition. [db242091](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/db24209161c124c8eef749f6213ba50bc4da383c)

## [26.2.0] - 2021-07-16

### Added

- GitHub Actions workflows now continue to run and report all job failures instead of immediately stopping on the first job failure. [d3c55e47](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d3c55e473aa00346ef9ae70d362589bcb16567d1)

## [26.1.1] - 2021-07-16

### Changed

- Optimized the Docker validation script to accurately detect the management IP address. [d0f881cd](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d0f881cd052278e2531538b26bd548d2c1b280a5)

## [26.1.0] - 2021-07-16

### Added

- Enabled code review and approval for pull requests through a new Pull Approve step in the CI pipeline, which requires one approval from a designated reviewer and has no breaking changes. [c8ba795a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c8ba795ad6915d8f91788fcfac1288423673510e)

## [26.0.1] - 2021-07-16

### Changed

- Improved Docker rootless setup validation to robustly handle various system configurations and user permissions, ensuring proper setup for rootless mode without requiring manual intervention. [bb602d18](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bb602d181315ff6f943c071d348e33abb2c50bbe)

## [26.0.0] - 2021-07-16

### Removed

- The randomization option for requesting reviews is now enabled by default for pull requests, allowing for more flexible review processes. [b9cf82b4](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b9cf82b4b8ac2cc644d58eb89d4ebb6be0ed4c4a)

## [25.1.9] - 2021-07-16

### Changed

- Upgraded pinned versions to PKG_HADOLINT_VERSION 2.5.0 and PKG_REGCLIENT_VERSION 0.3.4, potentially requiring users to update their dependencies and configurations to maintain compatibility. [b5bf4ced](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b5bf4ced35eb109db6ddbca79bf2c07c3a968dc8)

## [25.1.8] - 2021-07-16

### Changed

- Updated the pinned versions of required packages in the `pinned_versions.env` file, specifically Terraform which is now pinned to version 1.0.1, without introducing any breaking behavior or requiring migration. [b2e6921f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b2e6921f5838e754dfa0868d0466c45a7cb83c43)

## [25.1.7] - 2021-07-16

### Changed

- Optimized virtual machine configuration by dynamically determining available memory based on the host operating system and removing rsync arguments for improved performance and flexibility. [ad632f97](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ad632f971b1fef04d5ba9b8135cb43bef31f9928)

## [25.1.6] - 2021-07-16

### Changed

- Enabled support for openSUSE Leap in the qat-driver script, allowing users to install the QAT driver on this distribution without introducing any breaking changes or security concerns. [ad15a034](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ad15a034c37abbb7179ce032ac07878d412b3bed)

## [25.1.5] - 2021-07-16

### Changed

- Updated pinned versions in pinned_versions.env to use the Tekton client version 0.19.1, allowing for integration with Tekton pipelines. [a93ecc6e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a93ecc6e19999b75bd39673dd9b9f68fb569a480)

## [25.1.4] - 2021-07-16

### Changed

- Workflows are now triggered consistently on push and pull requests, including all image files and branches, regardless of type. [a61e08a0](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a61e08a0cd3fe497fc0d58d0f9d9e25f012bfdf2)

## [25.1.3] - 2021-07-16

### Changed

- Excluded CentOS 8 and OpenSUSE from the QAT driver matrix support, affecting users who rely on these platforms for QAT driver testing. [a2c0bcb3](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a2c0bcb3c9f353201bb8ea6dbf26cf200f18c04f)

## [25.1.2] - 2021-07-16

### Changed

- Enabled the qemu script on CentOS 8 to require perl as an additional dependency, necessitating its installation alongside existing requirements without introducing any API or CLI changes. [a20656ba](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a20656ba629e24f49c3e2162233ab25f34aa50bf)

## [25.1.1] - 2021-07-16

### Changed

- Streamlined the CI Check All action to check VM logs unconditionally and subsume memory and VM checks, simplifying the CI process. [9d9c4b14](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/9d9c4b14667f2505f038788d8e1d1a51590f9e7b)

## [25.1.0] - 2021-07-16

### Added

- Stabilized CentOS 8 support by updating to a stable image, ensuring consistency and predictability for users with no impact on API or CLI contracts, security risks, or migration requirements. [8be9ac5b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8be9ac5b2d59bbd661ee1539e2e445f1a43f2688)

## [25.0.1] - 2021-07-16

### Changed

- Upgraded the pinned versions of dependent packages in the `pinned_versions.env` file to Terraform 1.0.2 and Vagrant 2.2.17, replacing previous versions 1.0.1 and 2.2.16. [8b42b227](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8b42b22706dbba0da79b4d0baff2c788d3efeb04)

## [25.0.0] - 2021-07-16

### Removed

- Eliminated support for Pull Approve notifications and review assignments, requiring users to adjust their workflows accordingly. [7bb23dc2](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7bb23dc286d2c512a27a655a8d78cf94d22f6203)

## [24.0.3] - 2021-07-16

### Changed

- Upgraded pinned versions in the pinned_versions.env file to the latest available versions, requiring users to update their configurations to PKG_CRUN_VERSION=0.20.1, PKG_TERRAFORM_VERSION=1.0.0, and PKG_TKN_VERSION=0.19.0. [6e2b5527](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6e2b55275c252c03ec99a56bb74fddcdab8ccf72)

## [24.0.2] - 2021-07-16

### Changed

- Optimized the on-demand failure script to run on submitted pull request reviews and retrieve logs from running virtual machines. [6904a738](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6904a738d8c50e6dd81a8957a95817640e569713)

## [24.0.1] - 2021-07-16

### Changed

- Optimized on-demand CI task workflows to only trigger on specific paths being pushed or pulled, reducing unnecessary runs and improving overall performance. [65a06151](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/65a06151271b0ce632b26c5b04a7f36f0785f609)

## [24.0.0] - 2021-07-16

### Removed

- Eliminated support for openSUSE, requiring users to adjust their setup or migration scripts to accommodate this change. [5e1fc7aa](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5e1fc7aa1c4a3d82de5c1ee46e96c538e02a3cda)

## [23.2.6] - 2021-07-16

### Changed

- Improved Docker CI validation to provide more informative output and warn instead of erroring if Docker autocomplete functions are not installed. [5c5b05c2](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5c5b05c279c131351c6db6eca52d0ea2a9d4c048)

## [23.2.5] - 2021-07-16

### Changed

- Updated pinned versions in a file to reflect newer dependencies, including PKG_REGCLIENT_VERSION and PKG_TKN_VERSION, which were bumped to 0.3.5 and 0.20.0 respectively, while PKG_KN_VERSION and PKG_VAGRANT_VERSION remain unchanged, and users may need to update their dependencies to avoid breaking behavior. [5b803c87](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5b803c877347e775a17001a667b61769b279c944)

## [23.2.4] - 2021-07-16

### Changed

- Optimized CI resource allocation for hardware testing by reducing the number of CPUs and memory allocated for integration tests. [59aa53ff](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/59aa53ff31b30798aa46f122711c01d279f1a408)

## [23.2.3] - 2021-07-16

### Changed

- Updated the pinned versions in the pinned_versions.env file to reflect the latest versions of various packages, specifically upgrading PKG_HADOLINT_VERSION from 2.5.0 to 2.6.0 without introducing any breaking behavior, API or CLI contract changes, or security impact, and no migration steps are required. [500c682f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/500c682f9c5869a17d1dc022f58aeb1bcf11f978)

## [23.2.2] - 2021-07-16

### Changed

- Updated the pinned versions in the pinned_versions.env file to 7.3.2 for PKG_FLY_VERSION and 0.23.1 for PKG_KN_VERSION. [4eb98e44](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/4eb98e44dac7a381b0ffd808a91da233b9273356)

## [23.2.1] - 2021-07-16

### Changed

- Improved the CI workflow for the master branch to check pull requests in addition to pushes and to log check failures. [4b842404](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/4b8424042cce8331f50a9b1ae55851c37a66ce66)

## [23.2.0] - 2021-07-16

### Added

- Automated assignment of labels to pull requests is now enabled through a GitHub Actions workflow triggered on pull requests to the target repository. [47d130fc](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/47d130fca174af66da94264126592b1feda9b0b4)

## [23.1.4] - 2021-07-16

### Changed

- Overrode package version pinning to explicitly exclude the blacklisted version, requiring migration to update pinned versions. [3bc3da47](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3bc3da47aa6430f493e4dc86ec1c8dcd0db3cfb9)

## [23.1.3] - 2021-07-16

### Changed

- Upgraded pinned versions in the pinned_versions.env file to reflect newer versions of several packages, including Terraform Docs, which was updated from 0.13.0 to 0.14.0, and users may need to update their dependencies to avoid compatibility issues. [35d4e622](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/35d4e622e0f5f52824c1f4b5ce72100748aacc1e)

## [23.1.2] - 2021-07-16

### Changed

- Optimized ftrace setup instructions to improve compatibility with various architectures by adding a conditional check for the setcap command. [35768811](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/35768811d08cb90f369b7330afdeb5bc964cad11)

## [23.1.1] - 2021-07-16

### Changed

- Renamed the alias for openSUSE Tumbleweed in various workflows and configuration files to accurately reflect its name, requiring a migration to the new alias in affected workflows and configuration files without impacting the API or CLI contract. [2de82833](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2de82833e37fb06b542a8807bef715b50ab58188)

## [23.1.0] - 2021-07-16

### Added

- Improved system efficiency is now achieved through optimized memory management and context switching performance thanks to the introduction of Nested paging and VPIDS. [2a721ec4](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2a721ec42f6d87d060dbe8cfcd2a0183a74a5ca2)

## [23.0.5] - 2021-07-16

### Changed

- Upgraded pinned versions of several packages to 0.3.3 for PKG_REGCLIENT_VERSION and 0.15.5 for PKG_TERRAFORM_VERSION, with no breaking behavior or migration requirements introduced. [2504f9b8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2504f9b8d0bb0c7ff470295dd0f56be82a335eec)

## [23.0.4] - 2021-07-16

### Changed

- Simplified the wait process for various scripts to dynamically increase the delay with each attempt, starting from 2 seconds and doubling with each iteration. [1a2e2ccc](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1a2e2ccc0dd1e611fd998c1d7494c9594a99e4ad)

## [23.0.3] - 2021-07-16

### Changed

- Enabled support for openSUSE Leap, allowing users to run server-side and client-side scripts on this distribution. [1a098429](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1a098429c32ae4b3552b0d46bb0ea14dd3f6aca3)

## [23.0.2] - 2021-07-16

### Changed

- CI checks are now enabled for all pull requests, allowing for earlier validation and review of code quality and reliability. [185dfa63](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/185dfa63154109b47a68bb518867cb5fc63452af)

## [23.0.1] - 2021-07-16

### Changed

- Updated the pinned versions of crun, terraform-docs, and terraform to their latest versions, requiring users to adjust their configurations accordingly to maintain compatibility. [05b0d4af](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/05b0d4afb92660810a2c4719f19735e258476c8b)

## [23.0.0] - 2021-07-16

### Removed

- Eliminated support for ClearLinux distributions, simplifying the project to focus on CentOS, OpenSUSE, and Ubuntu. [723356ac](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/723356acdbaac22999ef8d76fb80d9ff53df8530)

## [22.3.0] - 2021-05-28

### Added

- Excluded the openSUSE DevOps profile from tests due to its isolated nature, affecting the on-demand CI workflow by removing the profile from the test matrix. [33c43c6d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/33c43c6d7689d7791ce6d2b8f29d579890fdfc9f)

## [22.2.0] - 2021-05-28

### Added

- Introduced virtio as the default network type in Vagrant configurations, which may require adjustments to existing configurations. [d873194c](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d873194c457282e5385185aa4fe16919e8ae49ec)

## [22.1.2] - 2021-05-28

### Changed

- Tests are now grouped by profile, with the selected profile determining which tests to execute based on a configurable list of profiles defined by the `PROFILE` environment variable. [0d9122b5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/0d9122b56c18739c9fbfffe2a38fb624c6708aa0)

## [22.1.1] - 2021-05-27

### Changed

- Updated the CI pipeline to use GitHub Actions, requiring users to update their CI configuration to ensure uninterrupted build and test processes. [947cf80e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/947cf80e0ab460e50b395119a73a575a1e408432)

## [22.1.0] - 2021-05-27

### Added

- Images are now automatically compressed in pull requests through the addition of a GitHub Actions workflow. [e3c67f9f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e3c67f9f67990d85df2868f979d39d723589d8fe)

## [22.0.9] - 2021-05-25

### Changed

- Updated pinned versions of several packages to reflect new dependencies, specifically bumping PKG_FLY_VERSION from 7.2.0 to 7.3.0. [1fba01b7](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1fba01b75a295dbc30abdf61bd35995e2d99fa90)

## [22.0.8] - 2021-05-25

### Changed

- The installation checker for Go is now correctly identifying and removing existing installations before installing a new version. [cc54e3d9](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/cc54e3d90cadbc78dda93ffa0eff360afd98cb7f)

## [22.0.7] - 2021-05-25

### Changed

- QEMU version auto-update support is now dynamically set based on the latest available release, replacing the hardcoded value. [0940893d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/0940893dbf4fbe5534b751d7ab0676de2ac48915)

## [22.0.6] - 2021-05-19

### Changed

- Upgraded the pinned version of Terraform to 0.15.4 in the pinned_versions.env file, ensuring dependencies remain up-to-date without affecting API or CLI contracts. [c63212f0](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c63212f0ec2d8c60798daf3c62f85e3b01ad6f10)

## [22.0.5] - 2021-05-19

### Changed

- Improved the robustness of CNI plugin validation by checking for the existence of the plugins folder before attempting to validate its contents. [4c967009](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/4c967009f28eedd58eef8d182ff54b08d80e7d40)

## [22.0.4] - 2021-05-19

### Changed

- Updated the default kustomize version to 4.1.2, which may require users to update their kustomize installations or configurations if they rely on the previous version. [5b444fb1](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5b444fb177f7da60c2bd30090060a12deece704a)

## [22.0.3] - 2021-05-19

### Changed

- Krew now fetches the version from the latest GitHub release instead of using the PKG_KREW_VERSION environment variable. [7fa3ba7a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7fa3ba7a68fdb81927e70f1413d818ecaedbc9d6)

## [22.0.2] - 2021-05-19

### Changed

- The go-lang script now retrieves the latest Go version from the official Go site, ensuring it always uses the latest available version. [560dd671](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/560dd67121573504090817e1411010d2b90256ee)

## [22.0.1] - 2021-05-19

### Changed

- Updated the CI version for PKG_KN_VERSION to 0.23.0 in the pinned versions configuration, with no breaking behavior, API or CLI changes, or security impact, and no migration steps required. [081cae37](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/081cae3773ec205d7c213694d151f86368b90539)

## [22.0.0] - 2021-05-19

### Removed

- The scripts now use the `uname` command to determine the OS and architecture, and then use sed to map the architecture to a specific string, replacing the previously used get_cpu_arch function. [efc8e7ff](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/efc8e7ff01b8dd0c2cde20a2f6c4568a7873ee50)

## [21.1.1] - 2021-05-18

### Changed

- Updated pinned versions to reflect the latest dependencies, bumping PKG_KIND_VERSION from 0.10.0 to 0.11.0 without introducing breaking behavior or requiring migration. [451994b9](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/451994b903cddad1c369c8a3ee8be806148543df)

## [21.1.0] - 2021-05-18

### Added

- Simplified the installation process by enabling one-command installation of the package and its dependencies. [fe1646a5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/fe1646a5d187fcea8c857aac5e5984119bdc5400)

## [21.0.0] - 2021-05-18

### Removed

- Simplified the NFS script to use the correct package manager for each system, eliminating the need for the install_pkg dependency. [bc885772](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bc885772f93e6802c651f74667fc56ba36598386)

## [20.6.5] - 2021-05-18

### Changed

- Enabled automated jq installation for users running Docker validation without prior installation, ensuring seamless validation without manual intervention. [331f6ae4](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/331f6ae44c86082919f96ae169a06a348f4713da)

## [20.6.4] - 2021-05-18

### Changed

- The podman validation script now correctly checks the kernel version before attempting to modify the containers storage configuration. [ee7aee4b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ee7aee4b6283b05d76bf77945dacb606bfc7db95)

## [20.6.3] - 2021-05-18

### Changed

- Upgraded Vagrant CI version to 2.2.16, requiring users to install this version for integration tests to run successfully. [b4f1d555](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b4f1d555bd99a356e724bf0f733559c562e55ba7)

## [20.6.2] - 2021-05-18

### Changed

- Upgraded the Node.js version from 15 to 16 in openSUSE, requiring users to update their scripts or dependencies if necessary to maintain compatibility and security. [6f8479e9](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6f8479e9117f10b7336abfb200a74c1a29f4e626)

## [20.6.1] - 2021-05-18

### Changed

- Migrated Ubuntu Xenial jobs to TravisCI, requiring users to update their configurations to use the new infrastructure. [2cd68fc5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2cd68fc58bcdd1fa6fb3beb4ce75339ab40044db)

## [20.6.0] - 2021-05-18

### Added

- Enabled skopeo support on non-x86 architectures in Ubuntu, allowing users to proceed with the installation despite a warning message. [08e765b3](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/08e765b34e07f0ae97852fb1d267ed66f8c5383f)

## [20.5.0] - 2021-05-18

### Added

- Automatically updated pinned versions in the repository are now enabled through a scheduled CI job. [097b9b0c](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/097b9b0cc47d6b005494b75eb1dc9b21264d458a)

## [20.4.0] - 2021-05-15

### Added

- Enabled users to customize the version of the regclient package by externalizing the PKG_REGCLIENT_VERSION variable, which can now be set as an environment variable. [ef0158a8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ef0158a892159a3304f967872b1fc7db053b9ada)

## [20.3.0] - 2021-05-15

### Added

- gomplate now allows users to customize the version used by setting the PKG_GOMPLATE_VERSION environment variable, which is automatically used in the Vagrantfile shell provision. [cd6189d0](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/cd6189d0af64a6e2793758a9241132f259fee543)

## [20.2.0] - 2021-05-15

### Added

- Enabled users to specify the Ninja version at runtime by making PKG_NINJA_VERSION an environment variable, impacting the QEMU Vagrant setup to include the version in the environment. [abafee06](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/abafee067411a80a5ffc218dd351c641011c4ad8)

## [20.1.3] - 2021-05-15

### Changed

- Pinned versions of dependent packages are now managed through a separate file, allowing for easier version control and updates in CI environments. [31a38b58](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/31a38b58c207e78f6f7d4ec0701110f28addf80b)

## [20.1.2] - 2021-05-14

### Changed

- The default version used for gomplate installation is now sourced from the PKG_GOMPLATE_VERSION variable. [3b04a049](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3b04a049d00314ad329047adaab35d518fa774c4)

## [20.1.1] - 2021-05-14

### Changed

- Enabled Terraform documentation management through the Terraform-docs tool, introducing a new environment variable to specify the Terraform docs version and updating scripts to install and configure the tool. [1a0ef225](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1a0ef225db2e00a80b5799bc8af9c6ae1b8fee02)

## [20.1.0] - 2021-05-14

### Added

- Enabled helm installation on OpenSUSE systems by installing the OpenSSL package, ensuring correct helm version 2 installation. [f9255374](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f925537442b2425f7220f044b8027d1394b1c4b6)

## [20.0.3] - 2021-05-14

### Changed

- Optimized the Docker registry images to use a specific image from Quay.io instead of Alpine. [6e49c233](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6e49c23388f095c5560fb5276af79da0698b0d8b)

## [20.0.2] - 2021-05-14

### Changed

- Enabled improved testing of OCI hooks with the introduction of ftrace analysis capabilities. [32389d4e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/32389d4eefce9c1d1db9dc81fa8ce33996f2e705)

## [20.0.1] - 2021-05-14

### Changed

- Upgraded QEMU to version 6.0.0, requiring users to update their QEMU version specification in the `PKG_QEMU_VERSION` environment variable. [a8af3209](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a8af320934b126c1f1057f7c60ec3959ef22509b)

## [20.0.0] - 2021-04-30

### Removed

- Eliminated the vagrant cache from Travis CI, which may require users to update their Vagrant setup to avoid cache-related issues. [7873e7d8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7873e7d88bbf05409389373594039f6f262cbbbb)

## [19.3.2] - 2021-04-30

### Changed

- Optimized the kubectl installation script to streamline the installation process by removing the redundant "access-matrix" plugin. [3e1932d6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3e1932d673989478c709dd030d2a8789779ebf28)

## [19.3.1] - 2021-04-28

### Changed

- Optimized support for openSUSE by enabling the distribution through modifications to the installer command and removing exclusion from the os-blacklist.conf file, resulting in improved support for the platform. [d8cd7a4c](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d8cd7a4c8a2dce9aa266f7e2fb3a4403611492fd)

## [19.3.0] - 2021-04-28

### Added

- Enabled code style and spelling error detection on the master branch through the addition of the Reviewdog GitHub Action, which runs on push events and requires a GitHub token stored as a secret. [bdd36e6a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bdd36e6a9364b3cd46c5b6d0603e03ffe1b18826)

## [19.2.1] - 2021-04-28

### Changed

- Enabled the installation of multiple Krew plugins at once through the kubectl script, allowing users to specify a comma-separated list of plugins to install. [b03637d0](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b03637d0994ae3eef7a8bc5d5ba08d4c4e5ee780)

## [19.2.0] - 2021-04-28

### Added

- Excluded the libvirt script for openSUSE from execution, adding 'opensuse' to the blacklist to prevent targeting of openSUSE users. [6903e8ef](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6903e8efecb07ac48f298f548c4c70cba4249576)

## [19.1.0] - 2021-04-28

### Added

- pipx has been enabled as a supported package manager, allowing users to leverage its features when installing the package. [5a111479](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5a111479446b547130ec14e10d45ff4427e776fd)

## [19.0.1] - 2021-04-28

### Changed

- Enabled GitHub Actions workflow for linting to check for broken links and use a different linter, introducing new jobs for super-linter and tox validation. [505609dc](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/505609dc54eda545a42eaca21bc19fc3d6c28655)

## [19.0.0] - 2021-04-28

### Removed

- Eliminated the os-blacklist.conf files for crystal and hadolint scripts, which may break behavior for users relying on these files. [2995b55c](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2995b55cf521f00cc1f1272826ee2ecab8178cf5)

## [18.6.1] - 2021-04-28

### Changed

- Optimized integration tests execution by removing redundant workflows and updating remaining workflows with additional environment variables for CPU, memory, and timeout. [0f20b722](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/0f20b722936e752eb439df826383a6a46e561555)

## [18.6.0] - 2021-04-27

### Added

- Enabled correct Helm v2 installation by updating the desired version to v2.17.0 for users who need to install Helm version 2, requiring them to update their installation scripts. [091093ad](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/091093ad26b587f25e6cf82257adab35675551a0)

## [18.5.1] - 2021-04-13

### Changed

- Updated the project's logos to new ones, affecting the appearance of documentation and potentially requiring updates to references to the old logos. [6425aef7](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6425aef79507889d7b8ac0bcadc55afbe8571075)

## [18.5.0] - 2021-04-13

### Added

- Introduced a Knative client script that enables users to install and manage Knative, a serverless cloud-native application platform, without introducing any breaking behavior or API changes. [369939ca](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/369939cafe11e6ac45a275114a769cbeeb9854a8)

## [18.4.1] - 2021-04-07

### Changed

- Enabled support for multiple Linux distributions by introducing separate workflow files for CentOS 8, openSUSE, Ubuntu Bionic, Ubuntu Focal, and Ubuntu Xenial. [2c723932](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2c723932dd98b1c5687c13c7f6021321b93a2e86)

## [18.4.0] - 2021-04-07

### Added

- Enabled immediate execution feedback on error, displaying the execution result in the CLI output to aid in diagnosing validation issues. [bb8adc4c](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bb8adc4c0198035b219547b18a0ec625728eac20)

## [18.3.3] - 2021-04-07

### Changed

- Test execution is now more reliable and consistent due to standardized log file management and controlled test environment. [fc23fd9f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/fc23fd9f165186428ee17bc19b73c0647cf88d17)

## [18.3.2] - 2021-04-07

### Changed

- Stabilized ctr execution to correctly target the containerd socket address, ensuring the plugins ls command functions as expected with no additional steps required. [77e5f055](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/77e5f055b7fbacc3884cd5eeadfd8b6aa65dcfe7)

## [18.3.1] - 2021-04-07

### Changed

- Tests now have a timeout of 900 seconds to prevent them from running indefinitely. [5c417888](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5c417888cb6b0c0cc3270da51ddbfa8e7eca1c8c)

## [18.3.0] - 2021-04-07

### Added

- Enabled podman installation on kernels older than 4.19 by modifying containers storage configuration to ensure compatibility. [a61b377e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a61b377e32edc66fb70f5088cc54464012be7225)

## [18.2.1] - 2021-04-07

### Changed

- Upgraded the QEMU version to 6.0.0-rc2 to resolve a compatibility issue with the `-no-pie` flag on openSUSE. [73554762](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/73554762184d20bc2616a6776ee80ce85768ebd6)

## [18.2.0] - 2021-04-07

### Added

- Optimized GitHub Actions execution to occur sequentially by default, requiring users to explicitly set max-parallel to 1 in their workflows to achieve parallel execution. [9edb8d08](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/9edb8d0874015c23511363e767f31b72f61a4cdb)

## [18.1.0] - 2021-04-07

### Added

- Introduced a continuous reporter that displays test status updates every minute, with its output redirected to the test log and its process ID stored for later use. [5e69fc63](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5e69fc63daf60915f8f317cc38fc9e1a72519b5b)

## [18.0.6] - 2021-04-07

### Changed

- Improved Docker plugin installation to correctly handle root user permissions, ensuring the plugin is accessible to both the current user and the root user. [a998529c](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a998529c2947e61190426d20ccea46e9082eddb0)

## [18.0.5] - 2021-04-06

### Changed

- Updated the pip URL for Python 3.5 to use a version-agnostic URL, requiring users to update scripts/pip/main.sh to the new URL to continue installing pip. [25ff35ea](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/25ff35eafb2774f3f847e18115628480c8865656)

## [18.0.4] - 2021-04-06

### Changed

- crun version validation is now accurately checked by properly comparing the installed version with the expected one. [cc89b514](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/cc89b514ba4f613df13260d1ab52c55c6b758756)

## [18.0.3] - 2021-04-06

### Changed

- CI workflows now determine whether to run long tests based on the presence of the `RUN_LONG_TESTS` variable, replacing the previously used `RUN_KVM_TESTS` variable. [1704cb79](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1704cb7944fdf45d9fa17ec1efc8019544df69c2)

## [18.0.2] - 2021-04-06

### Changed

- The vagrant plugin installation process now installs vagrant-reload and removes the explicit version requirement for vagrant-libvirt, introducing a new dependency that requires users and maintainers to update their plugins accordingly to avoid any issues. [3051120e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3051120e67303f873810c0fed5d901741f6bff23)

## [18.0.1] - 2021-04-06

### Changed

- Optimized the CI workflow to run tests on a broader range of operating systems, requiring users to update their CI configurations to match the new job matrix. [969e0477](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/969e0477fd770bc16ae25cf63b9e9bca087bbc0d)

## [18.0.0] - 2021-04-06

### Removed

- Simplified the build process by eliminating lint validation from TravisCI configuration. [e6c16958](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e6c169584f7f4bd9fee31f389177b2509e9bfb0e)

## [17.6.4] - 2021-04-06

### Changed

- QEMU workloads are now enabled by default in various Vagrant configurations, replacing the previous host-passthrough CPU mode, and users may need to update their configurations to accommodate this change. [05a99bce](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/05a99bce963ee53bd3421913dbc2fde507fc65c2)

## [17.6.3] - 2021-04-06

### Changed

- Code quality is now enforced through the introduction of a super-linter, which checks for coding standards and best practices and displays results in the GitHub workflow badge. [0c8a61bd](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/0c8a61bdfa30a9519ff3839eabf433d261c3687e)

## [17.6.2] - 2021-04-02

### Changed

- Optimized pip installation behavior to dynamically adjust to the version of pip being installed, ensuring compatibility and optimal installation results. [51938905](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/51938905958d6937424808a7965924e115aa3128)

## [17.6.1] - 2021-04-01

### Changed

- Optimized QAT driver support to include CentOS 8 and exclude Ubuntu 20.04, now requiring users on CentOS 8 to consider the QAT driver's limitations. [2786d9ab](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2786d9ab0d2920ada22607d1c0edf0e29f47319d)

## [17.6.0] - 2021-03-26

### Added

- Enabled Node.js support for the project, including installation, testing, and validation scripts that support Ubuntu, CentOS, and Fedora platforms with manual configuration required for OpenSUSE and ClearLinux. [de6a4956](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/de6a4956b896270eb583dcba292b4351311a3b4c)

## [17.5.0] - 2021-03-25

### Added

- Enabled support for template rendering with the addition of the gomplate script, which includes installation and validation tools, and a Vagrantfile for testing. [ce4dd67d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ce4dd67d46b4abe7ad7f74fe9a110dc9de2b4ce1)

## [17.4.4] - 2021-03-25

### Changed

- Enabled support for the Rust language, introducing a new package manager and its corresponding scripts without altering existing behavior or requiring migration. [955a1e3a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/955a1e3a5efb7b5695751fe30c77db543a349281)

## [17.4.3] - 2021-03-18

### Changed

- CNI plugin installation is now hardened by verifying the folder content before proceeding, ensuring the expected plugins are present. [c86b73a3](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c86b73a3b360f0ddaf46997f1e39cfb14085a866)

## [17.4.2] - 2021-03-17

### Changed

- pip installations on Python 2.7 are now incompatible due to the updated pip URL scheme. [d670e2b3](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d670e2b30a4d426e3046d835c35e933fc6a88c8f)

## [17.4.1] - 2021-02-18

### Changed

- Updated the management network addresses and names in Vagrantfiles to 10.0.2.0/24 and "administration" respectively for Docker, Kubernetes, and other affected tools. [5b48bffc](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5b48bffc18c6d5eb8db9c1b4c50c76ee483f0e45)

## [17.4.0] - 2021-02-18

### Added

- Automated testing and validation of the project's code is now enabled through the addition of a Tekton CI pipeline that checks for issues on various Linux distributions and runs linter tasks for tox and shellcheck. [09e3162b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/09e3162bba16041f3a0d82101f17a46d75ac76c0)

## [17.3.2] - 2021-02-10

### Changed

- Updated source file paths to use relative paths, improving portability and flexibility in script usage without requiring API contract changes or security updates. [e6634aab](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e6634aab9434908751638ad5012e73a05d357366)

## [17.3.1] - 2021-02-10

### Changed

- Updated the ClearLinux version in the readme to 34260, reflecting the latest version of ClearLinux and affecting users who rely on the readme for distribution information. [f1e133cb](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f1e133cb574f833172ea77c95444f826e6d1f3f6)

## [17.3.0] - 2021-02-10

### Added

- Introduced the tkn script as a command-line interface for interacting with Tekton pipelines, with no breaking behavior or migration requirements. [21c2fc8d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/21c2fc8d78cbb5eba6ad3575bbf3f6c25cb87fa5)

## [17.2.0] - 2021-02-08

### Added

- Enabled Concourse CI job execution for the build process through a new linter task and run task script, with no migration steps required and no impact on security. [e353e136](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e353e13644f41cd631801beceeb17a886ab45dff)

## [17.1.0] - 2021-02-04

### Added

- Enabled BMaaS references in various scripts' readme files, including Docker, Go-lang, Packer, and Skopeo, with no breaking behavior or API changes affecting users involved in Bare Metal as a Service. [6bddcb77](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6bddcb77a2b3c09972c22be999a1e28e26f7015d)

## [17.0.3] - 2021-02-04

### Changed

- pip now supports installation on various Debian versions, including Jessie, Stretch, and Buster. [a3d0d00b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a3d0d00be8a1f00612fe889f561c5e31c24e017a)

## [17.0.2] - 2021-02-02

### Changed

- Enabled tracing and debugging for users by allowing them to set the DEBUG variable to true and gain additional logging and output in various scripts. [e79bc683](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e79bc6830a8720d9549955b336700150250aecf6)

## [17.0.1] - 2021-02-01

### Changed

- The run_test function now uses the error function to handle validation errors, enabling it to exit the script with a non-zero status and provide a clear error message. [c13763d3](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c13763d3be893333b10b8893166e79a8de3707dc)

## [17.0.0] - 2021-02-01

### Removed

- Dropped support for CentOS 7 and Ubuntu Xenial due to the requirement for GLIBC_2.27 in version 1.20, requiring users to migrate to a supported version. [2732450e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2732450e74c8049b1b95ac89f038ec9cec1329b0)

## [16.7.2] - 2021-02-01

### Changed

- Optimized integration test execution by allowing multiple test scenarios to run simultaneously. [083482e5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/083482e5b9df42aa64985b9bacbdf0af4abce5b0)

## [16.7.1] - 2021-02-01

### Changed

- Updated the default QEMU version to 5.2.0, requiring a corresponding update in the environment variable PKG_QEMU_VERSION. [42e0cb1d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/42e0cb1d9a8906eedac3f7aa6a0e6f911abfd789)

## [16.7.0] - 2021-01-28

### Added

- Improved QEMU logging with added informational messages to track its installation and building process, providing more visibility into the build process without affecting the QEMU installation process or its functionality. [c53dee0c](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c53dee0cf11e86ac3c1054dd47c2e36eb4684763)

## [16.6.0] - 2021-01-28

### Added

- Improved VirtualBox logging verbosity to provide users with clearer installation steps and informative messages during the installation process. [43a3a47e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/43a3a47ec5d5376bd0db4de4e7ed1eddb3df0bae)

## [16.5.0] - 2021-01-28

### Added

- Improved logging now provides more detailed and informative messages during the installation and configuration process, enhancing visibility into the installation steps and potential issues for users. [9fc89d59](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/9fc89d5927e2019053795e8d99c5418579615594)

## [16.4.3] - 2021-01-28

### Changed

- Improved podman validation and logging to provide better error handling and more informative status checks. [2a46190c](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2a46190c48e8325f9b4842dd4246f7410e6715ad)

## [16.4.2] - 2021-01-28

### Changed

- Improved pip installation logic now uses the correct Python version and pip package for certain operations. [b7c2120c](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b7c2120cfd5e25d89abbf260cd7932adb895e1bf)

## [16.4.1] - 2021-01-28

### Changed

- Improved NFS validation and logging now provide more detailed and accurate information about the installation and status of NFS services, resulting in more verbose output from the NFS installation script when validating and starting NFS services. [df95b3d1](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/df95b3d13d1acb61ace8e8de138503a8bc94a695)

## [16.4.0] - 2021-01-28

### Added

- Enabled libvirt service setup and validation to ensure the service is active and running correctly during installation. [11b763fb](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/11b763fb049739d98644e773c0bc7de1456d6dd9)

## [16.3.5] - 2021-01-27

### Changed

- Modernized Docker setup in CentOS 7 to support rootless mode, allowing the Docker daemon to run without root privileges and requiring users and maintainers to migrate to the new setup by creating a rootless Docker context. [edb4ebfe](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/edb4ebfea703895115da0e258e4969f17185c9fa)

## [16.3.4] - 2021-01-27

### Changed

- Improved Helm validation to require manual service account creation for Helm 2 users and enhanced local repository checks for all versions. [81ee40ad](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/81ee40ad3784462c5e156d3d8a44cb53a5c00673)

## [16.3.3] - 2021-01-27

### Changed

- Improved log messages are now provided during integration tests, including network usage and test duration. [2757bf53](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2757bf53084eb4076676ed494e0ac5f9b7c10d3f)

## [16.3.2] - 2021-01-26

### Changed

- Qemu installation folder is now located in the user's home directory, potentially requiring manual cleanup of temporary files and affecting system-wide installations. [081f2c19](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/081f2c1942a98cabe87903dba3ce78d5bad2ab8d)

## [16.3.1] - 2021-01-26

### Changed

- pip installations are now handled differently to accommodate various Python versions without introducing any breaking behavior or security risks. [a3bea88d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a3bea88dfc20d1fae3de54f1769b48538afada19)

## [16.3.0] - 2021-01-13

### Added

- Enabled package management for qemu-utils across various Linux distributions, including Suse, Debian, RedHat, and ClearLinux, through the installation script. [98bb3c01](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/98bb3c013dcca107f897b5616e2b0f7ed43ceef5)

## [16.2.3] - 2020-12-19

### Changed

- Improved Docker information retrieval now provides more reliable and efficient waiting for the service to be available by introducing silent error handling for the `docker info` command and enabling detailed output when debugging is enabled. [73ebdca6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/73ebdca63ae868463ef72d3cfda30c6c7039be86)

## [16.2.2] - 2020-12-15

### Changed

- The default Kustomize version has been hardened to 3.8.8, removing its dependency on fetching the latest version from GitHub. [e7347895](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e734789528e80a7a87fb025d6b30b3302adaa37e)

## [16.2.1] - 2020-12-14

### Changed

- Enabled support for the skopeo command, a utility for working with container images and repositories, which is now installable on various Linux distributions. [3536c483](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3536c48397ca5481dce8fe80d7d21d41448abacc)

## [16.2.0] - 2020-12-14

### Added

- Enabled support for the fly package manager, allowing users to install and manage dependencies with it. [9cd2faa5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/9cd2faa5aad52395225b9237fa65a794a189fe1d)

## [16.1.1] - 2020-11-24

### Changed

- Updated the vagrant plugin version for libvirt to 0.2.1, allowing users to specify the version of libvirt to install via the --plugin-version option when running the vagrant plugin install command. [8ff2c792](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8ff2c7924636ee5732be4ff799b187a4cb8cc91b)

## [16.1.0] - 2020-11-23

### Added

- Automated Dockerfile linting is now enabled through the addition of a hadolint script, allowing users to validate their Docker images against best practices with no breaking behavior or migration requirements. [efed9120](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/efed9120858efda773eaed649adc75b057021d64)

## [16.0.0] - 2020-11-20

### Removed

- Eliminated the dependency on an external shortened link by updating the Travis CI configuration to install tox using pip. [e1a28d86](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e1a28d8613b8ae07b392771edd060684c8050851)

## [15.4.0] - 2020-11-20

### Added

- Enabled the vagrant-reload plugin in the CI process, introducing a new dependency for users who rely on vagrant plugins and requiring them to install vagrant-reload when running CI checks. [6f279b15](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6f279b155c1fd0dd63ce25ecd728e210cc15d864)

## [15.3.3] - 2020-11-20

### Changed

- Updated Travis CI versions to ensure compatibility with the latest dependencies, now exported as environment variables in the script. [754f921a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/754f921a05f2059290b212798850ba1c2977c3cf)

## [15.3.2] - 2020-11-20

### Changed

- Optimized the podman validation and installation process to support additional Linux distributions including Ubuntu 18.04 and CentOS 8. [c16ef1ee](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c16ef1ee31f1c48600b52e5613e2191fa3509c98)

## [15.3.1] - 2020-11-19

### Changed

- Modernized the default Docker context to support non-root container execution. [231ad8d8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/231ad8d82254dd060cb9584f05b998f24c9591f7)

## [15.3.0] - 2020-11-13

### Added

- Enabled users to customize Kubernetes resource configuration without templates or DSLs through the addition of kustomize support. [9e990f46](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/9e990f466c7bba373ea723deb605d20392a1dcf0)

## [15.2.0] - 2020-11-12

### Added

- Enabled users to interact with the registry API through Docker's plugin regctl, which is now installed and configurable by default. [bdf84984](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bdf84984dcf9a1783e3b79a64180ffa5ece48fee)

## [15.1.4] - 2020-11-12

### Changed

- Updated Terraform plugins folder creation logic to use different directory paths based on the Terraform version, affecting plugin directory creation for users managing multiple Terraform environments. [d80243b4](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d80243b43675d5c5c53842024fb20c58cd42aca3)

## [15.1.3] - 2020-10-30

### Changed

- Optimized dynamic get version methods to fetch the latest version of various dependencies from GitHub, replacing direct URL access with a more robust approach that affects scripts for vagrant, cni-plugins, kind, podman, and terraform without introducing any breaking behavior or requiring migration steps. [0b6e8440](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/0b6e8440321b8d06e716a0df62eeab511146b158)

## [15.1.2] - 2020-10-28

### Changed

- Enabled podman to run in rootless mode on supported Linux distributions, allowing users to run containers without root privileges. [23268a23](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/23268a239a756812cd4822b8a8b7e5f27e8c5a2c)

## [15.1.1] - 2020-10-27

### Changed

- TravisCI job configurations now explicitly exclude CentOS 7 due to unsupported podman service, resulting in a warning and error for users running podman on this OS. [176d4343](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/176d4343d0710f8b872d4cf6075e564f66017fab)

## [15.1.0] - 2020-10-27

### Added

- Enabled support for nested virtualization by default, impacting users who rely on this feature, which is now automatically configured in the Vagrantfile and validated by the updated validate.sh script. [8577a593](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8577a593febb89add9ac052510cea54f45900d66)

## [15.0.2] - 2020-10-27

### Changed

- The scripts now retrieve the latest version of tools from GitHub, enabling users to install the most current versions of tools such as CNI plugins, kind, podman, terraform, and vagrant. [82783ed4](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/82783ed41895ed222d77694227e2224faaa4fb67)

## [15.0.1] - 2020-10-27

### Changed

- Updated Terraform validation to check against the correct version, changing the expected version from 0.13.4 to 0.13.5, and users must ensure their environment is updated to avoid validation errors. [73753b75](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/73753b75fbd3706b0bb9fd94729910dbdfd1f304)

## [15.0.0] - 2020-10-27

### Removed

- The go-lang documentation was updated to eliminate a reference to the Kubernetes Reference Deployment, omitting the link from the previously listed resources. [46115d6f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/46115d6fc182769edcb63847b9214ac8d3135a7c)

## [14.2.0] - 2020-10-27

### Added

- Enabled support for the podman package manager and crun runtime, including installation and configuration scripts for various operating systems, with specific scripts for Clear Linux users who can continue to use the package without change. [97f86c19](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/97f86c191b4c61b0f1d4eaced332b0ec070592f0)

## [14.1.0] - 2020-10-09

### Added

- Introduced support for managing Container Network Interface (CNI) plugins through a new package manager, enabling users to install and manage various CNI plugins across different operating systems and versions. [e13e38b8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e13e38b83dd8f54930a89c76850e69c8a5ec339d)

## [14.0.0] - 2020-10-09

### Removed

- Simplified the configuration schema by eliminating the PKG_CPU_ARCH environment variable, which previously determined the CPU architecture for binary installation, resulting in reduced complexity and potential for errors. [7a45a288](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7a45a28873d0d6b2a2b7cba2e2f73e26efd08933)

## [13.6.2] - 2020-10-09

### Changed

- Simplified testing across multiple environments by introducing a dynamic TravisCI matrix that replaces redundant job configurations. [61bedc24](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/61bedc241126fa417f7375c79efb08e0582445b7)

## [13.6.1] - 2020-10-09

### Changed

- The get version function now includes retries to ensure the correct version is retrieved, retrying up to 5 times with a 2-second delay between attempts if the initial request fails. [7ba5ed0b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7ba5ed0b0e6d24d3de4fca7fe2c5200efafd04be)

## [13.6.0] - 2020-10-09

### Added

- Expanded operating system support and installation instructions were introduced to the Terraform documentation. [469199c5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/469199c5298aa7134acfd781a7ff1df2887827d6)

## [13.5.0] - 2020-10-09

### Added

- Introduced comprehensive QEMU documentation, including an operating system support matrix, usage instructions, environment variable information, a logo image, and a table listing supported operating systems and their versions, along with a script to install QEMU and PMDK. [b76fe94a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b76fe94a6f440442e1943ed973933d9eee583fba)

## [13.4.0] - 2020-10-09

### Added

- Enabled clear instructions for installing the QAT driver by adding a table listing environment variables and their descriptions, including the PKG_QAT_DRIVER_VERSION variable, which specifies the QAT driver version to be installed. [e0b364bf](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e0b364bf117ae88da07a6d3bf15f4f35b0c103ea)

## [13.3.0] - 2020-10-09

### Added

- Expanded operating system support matrix and usage instructions have been introduced into the PIP documentation. [471a54ee](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/471a54eeeac0479dd7291012e7b8bada1cb2a3d8)

## [13.2.0] - 2020-10-09

### Added

- Enabled clear guidance for NFS users by providing an operating system support matrix and detailed instructions for installation and configuration. [56a3d7de](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/56a3d7ded6c2fdbc12692cdb26d4a20e975da6cc)

## [13.1.0] - 2020-10-06

### Added

- Enabled support for various operating systems including Ubuntu, CentOS, and OpenSUSE by adding a table listing supported systems and providing a link to install libvirt using a script. [a788a870](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a788a870bd080c3d4f8c38c30c4379badd6a3c4a)

## [13.0.1] - 2020-10-06

### Changed

- Hardcoded versions of Go, Kind, and Terraform are now used in the CI environment, eliminating the dynamic versioning mechanism and resulting in a more consistent and predictable build process. [1d72f4f4](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1d72f4f424364e1b997deb56fdcd388823109c37)

## [13.0.0] - 2020-10-06

### Removed

- Eliminated the OpenSUSE Docker repository, requiring a manual refresh of the package list to ensure the updated package installation process. [111f84f5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/111f84f5895b26a56416a9a3fe31258107505b1c)

## [12.5.3] - 2020-10-06

### Changed

- Updated kubectl documentation to include a support matrix, environment variables for installing specific versions, operating system support, and usage instructions. [cc39d2e2](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/cc39d2e26c56d9e59e2bc68e79089dc047937a4a)

## [12.5.2] - 2020-10-06

### Changed

- Optimized the VirtualBox script to simplify installation across multiple Linux distributions. [7a4d86e9](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7a4d86e9cead2eaad7caf043ec3855ce1f942992)

## [12.5.1] - 2020-10-06

### Changed

- Updated the go-lang source path to resolve a broken build process, requiring users who rely on the Vagrantfile and validate.sh scripts to update their scripts to use the new path. [e5b2e87f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e5b2e87f91bcf47e39df677a609f2411da7ad8cb)

## [12.5.0] - 2020-10-05

### Added

- The KinD documentation has been enriched with a logo and environment variables for users to customize the tool installation. [d5d1b1b8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d5d1b1b8ff5d4c798ab0ad99116c00605bd9dbac)

## [12.4.0] - 2020-10-05

### Added

- Optimized Helm documentation with a support matrix and environment variables for Helm installation. [94d54857](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/94d54857e3af3e96128d785a8bded2324ada3c53)

## [12.3.1] - 2020-10-05

### Changed

- Updated the Crystal language setup process to support ClearLinux as a platform and updated installation instructions. [fb9b21ca](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/fb9b21ca57fec88ca890ccc7e4835aca1967c2b2)

## [12.3.0] - 2020-10-05

### Added

- Enabled clear installation and usage guidelines for the Go package through an updated documentation with a new image and improved readme content, including installation instructions and environment variables, as well as a link to QAT enablement on OKD. [20356b22](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/20356b226112d04662271a6367ea23c1c36f44a3)

## [12.2.0] - 2020-09-28

### Added

- Improved the Docker documentation with additional information on operating system support, usage instructions, and environment variables, including a support matrix and setup details. [acf6ad1b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/acf6ad1bdf36193d57897e8cf15fee3cbb5aebd0)

## [12.1.0] - 2020-09-28

### Added

- Optimized the Docker container build process by including README.md, Vagrantfile, and validate.sh, while continuing to exclude .DS_Store, with no migration steps or API changes required. [7e4cba1b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7e4cba1b2b9a054e4fdc6c5462477d411e9d9687)

## [12.0.0] - 2020-09-28

### Removed

- Optimized the default Docker configuration by eliminating the native.cgroupdriver option, which may necessitate manual updates to custom daemon.json configurations for users relying on this option. [01fa69a5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/01fa69a58e5cff6359e6cb2fbc46debf5cf7f7b2)

## [11.3.0] - 2020-09-26

### Added

- Updated Vagrant versions for Ubuntu boxes to 3.0.30, requiring users to update their existing configurations if necessary. [cc6f353d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/cc6f353def777d5ce23d89425b019165164c9a7c)

## [11.2.8] - 2020-09-26

### Changed

- TravisCI cache was enabled to improve build performance, requiring users to delete the existing cache directory at /home/travis/.vagrant.d/boxes to ensure proper initialization. [cd580b69](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/cd580b69cfbe0cd578fb78585a1b9acfb90d188c)

## [11.2.7] - 2020-09-25

### Changed

- The Go version retrieval process has been optimized to handle temporary server unavailability by introducing a retry mechanism that fetches the version up to 5 times with a 2-second delay between attempts, ensuring the latest version is obtained and allowing scripts that rely on the `go-lang` package to recover from server issues. [edc19f99](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/edc19f99f5da55cad86593cdb24f5295e665050e)

## [11.2.6] - 2020-09-25

### Changed

- Excluded Bionic and Focal Ubuntu versions from Crystal CI due to installation issues, requiring users to migrate to supported versions or use alternative installation methods. [db2ce64d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/db2ce64d2f53225165b17461040db33a57d8fb1a)

## [11.2.5] - 2020-09-25

### Changed

- Modernized package manager handling to support new package managers and updated existing ones. [416a402b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/416a402b8bed112c91c7bab18c500687d7e68aca)

## [11.2.4] - 2020-09-25

### Changed

- The mechanism for retrieving the KinD version is now more resilient to temporary API connectivity issues, allowing the script to recover from such issues. [31b32413](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/31b324137eadc7a09dc040e2aae96b6943fa92f7)

## [11.2.3] - 2020-09-25

### Changed

- The kind installation script now correctly identifies the installed kind version by checking for the presence of the kind command instead of kubectl. [20b45848](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/20b458485f2cebb391cf298232abf653f80e48c9)

## [11.2.2] - 2020-09-25

### Changed

- Improved Terraform version retrieval reliability by enabling repeated attempts with exponential backoff to handle temporary API unavailability. [06adc561](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/06adc5610c23a0916a57c83bc13bfea17e9099c9)

## [11.2.1] - 2020-09-25

### Changed

- TravisCI checks now persist vagrant instances after test failures, improving test reliability and reducing instance loss. [bd6478d6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bd6478d6d80bf9fcd31d69a0321ce9c7ae5927d3)

## [11.2.0] - 2020-09-24

### Added

- Enabled users to determine supported operating system versions for the QAT driver by introducing a clear OS support matrix. [e5436947](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e5436947d1668eabe32b3146b0d5f9501b398701)

## [11.1.3] - 2020-09-24

### Changed

- Updated the QAT driver version to 4.11.0, requiring users to update their systems to maintain compatibility with the new version string in the qat_driver_tarball and the default version used if PKG_QAT_DRIVER_VERSION is not set. [2e7754b2](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2e7754b2aca9a87711935a1fbdf5e7317cabb8e5)

## [11.1.2] - 2020-09-18

### Changed

- Enabled helm autocompletion for improved command-line interaction, with the validate.sh script now checking for its presence and the main.sh script installing it. [1b053423](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1b0534238ce6576d3ed05d17b3d699319a82b317)

## [11.1.1] - 2020-09-15

### Changed

- Enabled version information to be displayed on logs for kind, kubectl, terraform, and vagrant installations, adding transparency on installed software versions. [4d9792ce](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/4d9792cebf5b81dc2174bf82d36eb1657e7a9d82)

## [11.1.0] - 2020-09-11

### Added

- Enabled Docker autocomplete function allowing users to access command completion in their terminal, with no breaking changes required. [495fe60f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/495fe60fe3b9511b43592b08824f85b253859388)

## [11.0.2] - 2020-09-10

### Changed

- Enabled the dynamic default version of kind, terraform, and vagrant to be automatically fetched and updated from their respective GitHub repositories during the installation process. [6140ebd0](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6140ebd0d62c2c375562f5b60ec18d7f149b548c)

## [11.0.1] - 2020-09-09

### Changed

- The default Go version used by the scripts is now dynamically determined from the official Go site, replacing the hardcoded version 1.15.1, allowing for easier maintenance and updates. [60e8d4c7](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/60e8d4c7579be7a5687a5c2f8085f098a348b4ea)

## [11.0.0] - 2020-09-08

### Removed

- Eliminated pre-installed OS Go binaries to prevent conflicts with the installation procedure, ensuring the correct version of Go is installed without interruption. [824ddaee](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/824ddaee4895d65662ae39201c1e579d316de4b1)

## [10.1.1] - 2020-09-08

### Changed

- Updated the Go language version to 1.15.1, ensuring that installation and validation scripts work correctly with the latest version. [64fac4a6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/64fac4a67125e626cccdbaf2830c50a750c52739)

## [10.1.0] - 2020-09-08

### Added

- Enabled a practical example for users by introducing a use case for combining the cURL package installer with the bindep tool for multiOS installations. [24ac7dbe](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/24ac7dbedb1e0a419ce1e408ea32b7377ff2d90b)

## [10.0.0] - 2020-09-02

### Removed

- Simplified package manager commands to execute with elevated privileges, reducing the risk of unintended command execution and improving overall system security. [8caf18ed](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8caf18ed9310e2a13cefd6dd9dfacae1e17d53e4)

## [9.1.4] - 2020-09-02

### Changed

- Optimized the crystal-lang installation process by utilizing the native package manager for each Linux distribution. [d8980d8d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d8980d8d79a1ef05ee8b2fb9b52399defa9ed05e)

## [9.1.3] - 2020-09-01

### Changed

- Enabled kind autocomplete function allowing users to access kind commands through their shell. [045218e6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/045218e6caf3f34273a32b44c123f0c3200ec5a7)

## [9.1.2] - 2020-09-01

### Changed

- Updated kubectl to enable autocomplete functionality, providing users with command suggestions while typing. [3a5ec9ce](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3a5ec9ceed69bd941d2f068ab7a68b10a1512ae5)

## [9.1.1] - 2020-08-28

### Changed

- Enabled the yamllint tool for YAML syntax checks in project configuration files, with no impact on the project's API or CLI contract. [361574f7](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/361574f72b5006c08cde2022d08a43dbfd402dba)

## [9.1.0] - 2020-08-26

### Added

- Improved the installation instructions by introducing a shortened link that redirects to the actual install script URL. [b3dc1586](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b3dc15865cbfb081d7a2fcb23ee7e25c3bc8d94a)

## [9.0.1] - 2020-08-26

### Changed

- Updated installation scripts and dependencies to correctly install and configure QEMU version 5.1.0 across various Linux distributions, including Ubuntu, Debian, and RHEL. [eda92715](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/eda927156c343dc0f3cb707d273483173a60c3de)

## [9.0.0] - 2020-08-26

### Removed

- Eliminated the self-referential invocation of the check.sh script, which no longer needs to be run as part of the build process. [e28a432d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e28a432d5a7c70e6d8684143a0f3a497af24206e)

## [8.4.0] - 2020-08-26

### Added

- Enabled users to monitor system performance by including CPU and memory metrics in the error message. [0948bd6a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/0948bd6a921d09247da342391ef230f89fa7811b)

## [8.3.2] - 2020-08-26

### Changed

- Upgraded the vagrant version to 2.2.10, enabling vagrant autocomplete in the main.sh script and updating the validate.sh script to test vagrant's operation and autocomplete functions. [3793ac1d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3793ac1d8d921cc1b1247202270815296fa4938a)

## [8.3.1] - 2020-08-24

### Changed

- Enabled setuptools for PIP 2 installations by default, ensuring compatibility with older systems such as Ubuntu 18.04 and below. [9bfb4b66](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/9bfb4b668eb7126f28e9e1c9661d49b3863b5d97)

## [8.3.0] - 2020-08-19

### Added

- pip installations can now be made without modifying the system PATH environment variable. [2f7104e0](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2f7104e03648bb34ab87ea579a51b4b0903ada61)

## [8.2.5] - 2020-08-14

### Changed

- The vagrant script now dynamically selects the correct architecture for clear-linux-os packages based on the detected CPU architecture. [b5ae6fd5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b5ae6fd50f944f994c1bf6189bb08d771a47fb78)

## [8.2.4] - 2020-08-14

### Changed

- The terraform script now automatically detects and uses the correct CPU architecture to download the Terraform package. [f7373c11](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f7373c113f5285ed9732a02cbcf30e97b584d05f)

## [8.2.3] - 2020-08-14

### Changed

- Automated CPU architecture detection is now enabled in the qemu script, simplifying package installation and ensuring accurate configure flags based on the detected architecture. [92e684d3](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/92e684d3342280911f58451d7142d95e94a6a418)

## [8.2.2] - 2020-08-14

### Changed

- Modernized the kubectl script to dynamically generate download URLs for kubectl and krew binaries based on the system's CPU architecture. [f2012c1b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f2012c1b11d4bd4eaf86ef26d4c66ce6438c3622)

## [8.2.1] - 2020-08-14

### Changed

- Modernized the kind script to dynamically determine the CPU architecture, which now influences the download URL for the kind binary. [5c7de364](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5c7de3640485e48e5471e2e1c4c53fab7656e4a7)

## [8.2.0] - 2020-08-14

### Added

- Enabled support for running VirtualBox on CentOS images. [f3d65e9f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f3d65e9f06d6da56496ed6ec411bf4d81a2e769a)

## [8.1.1] - 2020-08-14

### Changed

- Upgraded the project to use the latest Go version 1.15, which may necessitate updating dependencies for users who have not yet migrated. [bb4500dd](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bb4500dd973ca386c8770a2de62e54fc52d9b597)

## [8.1.0] - 2020-08-14

### Added

- Enabled robust validation for VirtualBox environments by verifying the presence and version of the VBoxManage command. [527a3c3c](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/527a3c3c319bfc4d9e3541a2647300ada1c5030e)

## [8.0.1] - 2020-08-14

### Changed

- Simplified the output of the check.sh script to display more concise test progress and completion messages. [5c89d169](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5c89d1694d5722aa9cd038f87ffaede1c97a7edb)

## [8.0.0] - 2020-08-06

### Removed

- The pinned version of Vagrant boxes is no longer managed, allowing for more flexibility in box version management but requiring manual updates to ensure boxes remain up-to-date. [054a9188](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/054a91884c68af318c6181b012999f567c9a617e)

## [7.2.1] - 2020-08-06

### Changed

- Tests are now filtered out for specific operating system versions to prevent known issues and improve overall test reliability. [331969cc](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/331969cc3237fde3cf9f8d7fc049954c93480bda)

## [7.2.0] - 2020-08-05

### Added

- Introduced support for installing and managing the Intel QuickAssist Technology driver across various Linux distributions including Suse, Debian, RedHat, and ClearLinux. [bcf1912b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bcf1912b37ac115d1215903610b282ec93331150)

## [7.1.1] - 2020-08-05

### Changed

- Updated the list of supported Linux distributions to include the latest versions of ClearLinux, CentOS 7, and OpenSuse. [400a1958](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/400a1958096d837e8fcefc8a48bbee2f98e8baa3)

## [7.1.0] - 2020-08-05

### Added

- Enabled sysfsutils support in the installation script, allowing users to install the package correctly for different Linux distributions. [14890ec2](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/14890ec27e2500df6931b8ed3457e9974bd1ccf1)

## [7.0.1] - 2020-08-04

### Changed

- Updated the openSUSE box version in the supported distributions list to 1.0.20200802, ensuring users have access to the latest version without introducing any breaking behavior or migration requirements. [5e84a65d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5e84a65db1907e97c19f5d62ad5525e788abd01a)

## [7.0.0] - 2020-08-04

### Removed

- Travis CI cache is no longer automatically cleared during builds, and users must manually clear the cache in their workflows to maintain consistent behavior. [ce937c76](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ce937c766e8c2608cdde7e66d8eb9b30f23f2b9f)

## [6.0.1] - 2020-08-04

### Changed

- The QEMU installation process on QEMU has been optimized for the opensuse case by automatically installing the necessary RPMs for libpmem if they are not already present. [e4ee58c1](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e4ee58c155eaa8ecd0dafc3313903acc287a4d04)

## [6.0.0] - 2020-08-04

### Removed

- Simplified the execution of vagrant commands by requiring sudo privileges to run vagrant up and destroy commands, necessitating updates to scripts to use sudo. [68230d9e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/68230d9edddcb7493056833684928925dd2c64b7)

## [5.0.3] - 2020-07-31

### Changed

- Updated the python3 installation process for openSUSE to correctly install python38 instead of python3, ensuring compatibility with the latest Python version. [45d02649](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/45d026492a199a4b07fe19216389760ec2ddce4b)

## [5.0.2] - 2020-07-31

### Changed

- Updated the list of supported Linux distributions to include the latest versions of ClearLinux, CentOS 7 and 8, Ubuntu Xenial, Bionic, Focal, and Opensuse. [9e66adaa](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/9e66adaab35cb0d550970e82ac7da37c6757f75d)

## [5.0.1] - 2020-07-24

### Changed

- Enabled support for NFS by introducing a new installation script that configures the service and firewall for multiple distributions, including ClearLinux, with no breaking changes but requiring additional configuration from users. [003fe99d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/003fe99d2efce4cfbc4bfe39909ac10002dfc8ec)

## [5.0.0] - 2020-07-24

### Removed

- The libvirt validation was eliminated from the installation script, allowing for more flexible package management but potentially breaking functionality if the libvirt group is not properly configured. [6160afff](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6160afff44b7c62cff7cce69f929d485a5beb705)

## [4.3.1] - 2020-07-20

### Changed

- Optimized the output of CI tests to display logs in a standard format and catch error messages for improved visibility. [b31185db](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b31185db2192d92e15f9efb8602fd9ffc84ec6ab)

## [4.3.0] - 2020-07-20

### Added

- Enabled more comprehensive QEMU script validation by introducing new test cases that cover image creation and execution of the x86_64 binary. [0c2ea7c7](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/0c2ea7c7ffe6465e03d7da397024548dc49dd823)

## [4.2.10] - 2020-07-20

### Changed

- Updated the list of supported Linux distributions to include newer versions of ClearLinux, CentOS, Ubuntu, and OpenSuse, ensuring users can utilize the latest available versions of these operating systems. [605835fd](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/605835fdf8f47a88c217dd8d2193678ac8e4d56b)

## [4.2.9] - 2020-07-11

### Changed

- Simplified the TravisCI execution process by streamlining the installation of dependencies and plugins, reducing redundant environment variables, and optimizing the execution of integration tests for various Linux distributions. [d4f853d7](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d4f853d77ef5f405673194f67459a1aacd0e13fe)

## [4.2.8] - 2020-07-11

### Changed

- Updated VirtualBox installation scripts to correctly support CentOS 8 and openSUSE by enabling users to install and use VirtualBox on these distributions. [fd61270f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/fd61270fc8c9604173ab2d749e34623439d6198b)

## [4.2.7] - 2020-07-11

### Changed

- Enabled qemu installation on openSUSE by requiring the diffutils package to be installed alongside other dependencies. [f337a4eb](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f337a4eb731b4e018baa2c182a6b4c3ef78697ab)

## [4.2.6] - 2020-07-11

### Changed

- Modernized the installation script to include additional packages, specifically bridge-utils, dnsmasq, ebtables, and ruby-devel, which affects package management and may require migration for Clear Linux maintainers. [f177e94f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f177e94f8efe1611d272187913af85cb730e32de)

## [4.2.5] - 2020-07-11

### Changed

- pip installation for Ubuntu focal has been optimized to correctly install Python 3.7 and its dependencies. [b4bbedce](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b4bbedce09de77dacb53e9a893e93ba50ab85dd3)

## [4.2.4] - 2020-07-11

### Changed

- Simplified the management of supported distros by storing the list in a single YAML file and standardizing the way Vagrantfiles define and configure boxes. [a54359df](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a54359df6ff6375704a33d23252ac44f42b1e57c)

## [4.2.3] - 2020-07-11

### Changed

- Updated the list of supported Linux distributions to include the latest version of OpenSUSE, which will now be validated and updated to the latest version when running the `update.sh` script. [59ece983](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/59ece983a237fae9ac9fc5b0f0ff54f79ecafe82)

## [4.2.2] - 2020-07-11

### Changed

- Updated qemu dependencies to ensure correct installation and usage on certain Linux distributions by adding a check for the qemu-img command and updating package dependencies. [3197ad5d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3197ad5d4f3dd63d436df0f267e8818fe982efb2)

## [4.2.1] - 2020-07-11

### Changed

- TravisCI now supports OpenSUSE Tumbleweed validation, enabling the testing of this Linux distribution. [2bc4203c](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2bc4203c3753e4c5ec074be49f9866c22fcf0c03)

## [4.2.0] - 2020-07-11

### Added

- Enabled tox as a package manager option, allowing users to install dependencies using the tox tool. [2532b7d3](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2532b7d323e8c7a040411f6872a6b20f0d1f6965)

## [4.1.1] - 2020-07-11

### Changed

- Modernized the Docker setup script for CentOS to utilize the IPTables backend for FirewallD, updating the FirewallBackend configuration in firewalld.conf to use iptables without impacting security or API/CLI contracts and requiring no breaking behavior or migration steps. [101d09e7](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/101d09e724649be88bb06f95923163f5a307032b)

## [4.1.0] - 2020-07-11

### Added

- Introduced support for platform virtualization management through the addition of a libvirt installation script, which includes installation and configuration for various operating systems and a Vagrantfile for virtual machine management. [48b54dfd](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/48b54dfd842c15568abd8fc5a6b7d7d75cb2f27e)

## [4.0.0] - 2020-07-07

### Removed

- Dropped support for openSUSE 42.3, requiring users to migrate to a supported version. [ab3893da](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ab3893daad3018b2cda4803b4dfd3174d3f65cd0)

## [3.3.3] - 2020-07-07

### Changed

- Automated end-to-end integration testing has been enabled across various Linux distributions, with updated validation jobs for lint, CentOS, and Ubuntu environments. [d1dfbad3](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d1dfbad30c36ca66dcb0084263562d76833b610a)

## [3.3.2] - 2020-07-06

### Changed

- pip now uses the --no-cache-dir option by default when installing packages, which can improve performance by reducing the amount of data pip needs to store. [ef1c0e42](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ef1c0e42d196056abe71c9fe4a1f89149fbae2bf)

## [3.3.1] - 2020-07-06

### Changed

- Updated the list of supported Linux distributions to reflect new version numbers for ClearLinux, CentOS 7 and 8, Ubuntu Xenial, Bionic, Focal, OpenSuse 15 and 42, now at 3.0.10. [e6b2f3de](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e6b2f3dedb9f6edd880a7c1df2e4994f180c06b7)

## [3.3.0] - 2020-07-06

### Added

- Introduced support for bindep package managers, allowing the installation script to dynamically adjust its behavior based on the presence of this package manager. [763ef636](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/763ef63665314dbcd1749af0f06c6378a4cfb095)

## [3.2.6] - 2020-07-06

### Changed

- Updated the list of supported Linux distributions to reflect the latest version numbers, incrementing those for ClearLinux, CentOS 7 and 8, Ubuntu Xenial, Bionic, Focal, and OpenSuse 15 and 42 to 3.0.8, without introducing breaking behavior or requiring migration steps. [6678ba99](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6678ba994f5977f0596a3a80d4a04869d3174cf1)

## [3.2.5] - 2020-07-06

### Changed

- Updated the project's Go language version to 1.14.4, requiring a rebuild to reflect the new version. [e6946d8a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e6946d8a3e089d49e14fc1de13e9115c79a9397c)

## [3.2.4] - 2020-05-28

### Changed

- Enabled users to specify a mirror for Docker registries, allowing them to use a local registry mirror in their Docker configuration. [9c4b54b8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/9c4b54b85b3d5a4cabe6d960d11c3b54740ac221)

## [3.2.3] - 2020-05-27

### Changed

- Updated the list of supported Linux distributions to include new version numbers for ClearLinux, CentOS 7 and 8, Ubuntu Xenial, Bionic, Focal, and OpenSUSE 15 and 42. [5de39571](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5de39571318b6872c9dfe1988e6bcd356fc80a8c)

## [3.2.2] - 2020-05-27

### Changed

- Experimental Docker features are now enabled by default, requiring no additional configuration from users who rely on these features. [d9df6881](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d9df688116a18f4104fc8d4a4d879d13afce1cf3)

## [3.2.1] - 2020-05-27

### Changed

- Moved the installation of kubectl binaries to the system's /usr/local/bin directory, requiring users to update their installation process accordingly. [918d89c5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/918d89c5943b564f6c2e10022a3e6db6b2a1b704)

## [3.2.0] - 2020-05-27

### Added

- Enabled automatic system service restarts for Ubuntu-based systems without prompting for confirmation. [42567d7c](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/42567d7c861221538eb8b56cf5350969ccb6507c)

## [3.1.1] - 2020-05-27

### Changed

- Updated the supported distributions to use Roboxes images, replacing previous boxes and versions, affecting ClearLinux, CentOS 7 and 8, Ubuntu Xenial, Bionic, and Focal, and OpenSuse 15 and 42. [156af57a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/156af57a935f666b3d712a20f8fd13d3d66742bc)

## [3.1.0] - 2020-05-27

### Added

- Enabled users to manage Kubernetes applications with Helm Charts through the addition of a helm package manager and supporting scripts. [77865303](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/77865303f223aab2d492d446dc4c8d6f4a4ebfb9)

## [3.0.0] - 2020-05-15

### Removed

- Raspbian support has been discontinued, requiring users to migrate their setup to Ubuntu or Debian if they were relying on this distribution. [94f44136](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/94f441363669a0fb5fe318661f86c98afa52826a)

## [2.5.1] - 2020-05-11

### Changed

- Updated Vagrant version to 2.2.9, requiring no migration steps and ensuring users' installations meet the new version requirement. [dec576e3](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/dec576e340708e5d2d1f7493085aef1b730c33ef)

## [2.5.0] - 2020-05-11

### Added

- Enabled support for QEMU virtual machines by introducing a script that allows users to install and manage them, supporting various operating systems including Suse, Debian, RedHat, and ClearLinux, with configuration and validation steps. [fac2e7ab](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/fac2e7abe81f16082790cf64bc343f266c01bc9c)

## [2.4.4] - 2020-05-05

### Changed

- The CPU architecture for installing kind and kubectl binaries is now determined by the PKG_CPU_ARCH environment variable or the system architecture. [e560a560](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e560a560de7a7b894b70f1ad5aba3e9196311418)

## [2.4.3] - 2020-05-05

### Changed

- The script has been optimized to support Raspbian installations, enabling users to install dependencies and tools on this Linux distribution. [051f0281](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/051f02814afda83ff47415df906cd06dab66098a)

## [2.4.2] - 2020-05-05

### Changed

- Modernized the Docker daemon options in the system's scripts to allow for more flexible configuration, enabling customization of the cgroup driver and default address pools through environment variables. [f6970f46](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f6970f46947a1cff4571be61aca131b74a4a0d7f)

## [2.4.1] - 2020-05-04

### Changed

- Enabled users to configure default address pools for Docker containers through the introduction of a new daemon option. [8692fc2f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8692fc2f22c497631a91043befa57e8da131ec42)

## [2.4.0] - 2020-05-04

### Added

- simplified the Docker cgroup management by switching to the systemd driver, streamlining the view of allocated resources for Kubernetes and eliminating the need for two cgroup managers. [82abfd12](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/82abfd127484fdf869d814677f9c60b2d7ddbb32)

## [2.3.4] - 2020-05-04

### Changed

- Updated the kind version to 0.8.1, requiring users to install the new version to maintain compatibility with the affected script. [cb55fe3a](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/cb55fe3af14747c364288fb518d9afbf5051dba2)

## [2.3.3] - 2020-05-04

### Changed

- Updated Terraform version to 0.12.24, requiring users with custom versions to update their configurations accordingly. [bc6fd099](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bc6fd099f90e37820a80bcbcb64eb60727c6eda4)

## [2.3.2] - 2020-05-04

### Changed

- Upgraded the Go language version used in the build process to 1.14.2. [f818bb8b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f818bb8b72645e4d17263425ab711c46137ffec2)

## [2.3.1] - 2020-05-04

### Changed

- Updated the list of supported Linux distributions to include the latest versions of ClearLinux, Ubuntu, and OpenSUSE, with version numbers incremented to reflect the latest available versions. [f3fdab40](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f3fdab40b0787796708cdcb76d0298846f010ae6)

## [2.3.0] - 2020-05-04

### Added

- Enabled users to install and run Kubernetes clusters locally using Docker container "nodes" by including support for various package managers and operating systems. [8a3e8a21](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/8a3e8a21cea09af000139c278f7779c503206ca1)

## [2.2.2] - 2020-05-04

### Changed

- Updated the list of supported Linux distributions to reflect the latest versions of ClearLinux, CentOS, Ubuntu, and OpenSUSE. [7bc58a5d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7bc58a5d7ad60895508de4a9c3e0fd8ccd7e55ee)

## [2.2.1] - 2020-05-04

### Changed

- Enabled Ubuntu Focal support in the CI environment, allowing it to be built and tested alongside other supported distributions. [6b19371e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/6b19371e15f638f321c071d45a8f20496ca95b25)

## [2.2.0] - 2020-05-04

### Added

- Enabled installation of Kubernetes command-line tool and Krew through the addition of a kubectl installation script that installs and configures them for use. [2832deb0](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2832deb0f5d3938cd0f0f068b3eb489d5c2ea8db)

## [2.1.5] - 2020-05-04

### Changed

- Renamed the environment variable PKG_MGR_DEBUG to PKG_DEBUG, which affects various scripts and provisioning configurations, including Vagrantfiles and shell scripts. [1e5b3139](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1e5b3139b47c7f9df7c5eca6896ec209fe2b6af5)

## [2.1.4] - 2020-05-04

### Changed

- The readme file now includes a license badge and a link to the Apache 2.0 license, as well as a link to the Travis CI build status badge. [d762e82b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d762e82ba250acaa6e486ea8d907f0a763bd54fc)

## [2.1.3] - 2020-05-04

### Changed

- Renamed the go-lang script to go-lang in various files, including the install.sh script and README.md file, with the result that go-lang is now listed as supported on Suse, Debian, RedHat, and ClearLinux. [c668d314](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c668d3141929845f01fed955bd1e305f3d0987e6)

## [2.1.2] - 2020-05-04

### Changed

- Updated the list of supported Linux distributions to include ClearLinux with version 32740. [bf375e87](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bf375e87c7968e8968ac2c7a9ad02d7a058722b3)

## [2.1.1] - 2020-05-04

### Changed

- Updated the list of supported Linux distributions to reflect the latest version numbers for ClearLinux, CentOS 7, and OpenSuse, incrementing their versions to 32670, 1905.01, and 1.0.20200322 respectively. [a35ab798](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a35ab7981a8889c9cbb63f3dcb669997083f1ae6)

## [2.1.0] - 2020-05-04

### Added

- Enabled support for the Crystal programming language by adding a new installation script that allows users to install and validate it on various Linux distributions. [7e4fe6d8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7e4fe6d89eeef7d3cb1efcc0360fb0ea1c7cac05)

## [2.0.16] - 2020-05-04

### Changed

- The Ubuntu install command now suppresses the installation of recommended packages by default, which may impact users relying on these packages. [388bf1e4](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/388bf1e4cbdfc7dbb1aaa01b29f17e9006f23208)

## [2.0.15] - 2020-05-04

### Changed

- Optimized default memory allocation for virtual machines deployed with virtualbox or libvirt providers, reducing the number of memory requests from 1024 to 512. [3544d692](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3544d6925d838c7ffe575c8c77d3033a95dc1215)

## [2.0.14] - 2020-05-04

### Changed

- Corrected the typo in package manager metadata update behavior and CLI contract by replacing PKG_UDPATE with PKG_UPDATE in installation scripts and readme. [2a7ca30f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2a7ca30f404e4da05f7f75471544db675928652e)

## [2.0.13] - 2020-05-04

### Changed

- Enabled debug mode for package manager operations by default for some installations. [bd8e0842](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bd8e084299d3fb89d35b4dca445fb8c4274244f8)

## [2.0.12] - 2020-03-19

### Changed

- Updated the list of supported Linux distributions to include the latest versions of ClearLinux, CentOS 7, and OpenSuse, with version numbers incremented to 32610, 1905.01, and 1.0.20200314 respectively. [b9231649](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b9231649b8ce90e9cd3bf355d4f1641ef631e04b)

## [2.0.11] - 2020-03-19

### Changed

- The script now correctly handles user membership in the Docker group, ensuring proper access for users without requiring any migration steps or changes to the config schema. [77504081](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/77504081cdbee1d32e426289b92fd44ee7026620)

## [2.0.10] - 2020-03-06

### Changed

- Optimized memory allocation for Vagrant virtual machines by reducing the default memory allocation from 1024 MB to 512 MB, affecting all providers including virtualbox and libvirt. [d568de5e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d568de5e2677ca3d4e69f74de4f0af4e47b6aabd)

## [2.0.9] - 2020-03-06

### Changed

- Updated the default VirtualBox version to 6.1, which affects users who rely on this version for their virtualization needs and may require manual adjustments for those previously using the older version. [2df5f768](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2df5f7683afe0eb1a75cf6233a51753ab2ffa01a)

## [2.0.8] - 2020-03-06

### Changed

- Updated Terraform's default version to 0.12.23, requiring users with scripts or configurations tied to the previous version to update them to the new default. [e169870b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e169870b22c850fe779f9b8b5404238ec702b476)

## [2.0.7] - 2020-03-06

### Changed

- Updated the default Go version in the build script from 1.13.5 to 1.14, requiring users to rebuild their projects to utilize the new version. [2d6f3873](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/2d6f387324fe07384e71ee1f6172a4e446e17297)

## [2.0.6] - 2020-03-06

### Changed

- VirtualBox support has been modernized to use a more general provision, breaking the behavior of previous VirtualBox configurations and requiring users to update their Vagrantfiles to use the new provision. [1d0b7035](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/1d0b7035076866aface324ef99aaf462c3c8837b)

## [2.0.5] - 2020-03-06

### Changed

- Updated the list of supported Linux distributions to include new versions for ClearLinux, Ubuntu Xenial, Ubuntu Bionic, CentOS 8, and OpenSuse, while removing or replacing others. [960ff4ea](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/960ff4eab057b8a7988dbf736237e0a9e007edd8)

## [2.0.4] - 2020-02-28

### Changed

- Optimized the provisioning process by enabling users to create and manage virtual Ethernet devices with the addition of Docker support for Veth interfaces. [aa92b694](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/aa92b6946ef28f83e0523ac4219db8346b198c88)

## [2.0.3] - 2020-02-25

### Changed

- Updated the list of supported Linux distributions to include the latest versions of ClearLinux, CentOS 7 and 8, Ubuntu Bionic, and OpenSuse. [c7b73ac6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c7b73ac697a8a9cd557518b4dc3f8c5971dc3ddd)

## [2.0.2] - 2020-02-25

### Changed

- pip install now supports the installation of Python2 packages. [72ac4382](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/72ac4382084a81c4554a977718003400df28bb6c)

## [2.0.1] - 2020-02-21

### Changed

- The URL used for installing packages was updated to a new endpoint, ensuring continued access to dependencies like wget, unzip, and gnupg, but may require manual intervention or migration steps to adapt to the change. [30881750](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3088175031468cf0f05d9f29ca022ead6085ba2c)

## [2.0.0] - 2020-02-21

### Removed

- Eliminated the project's dependency on Go (Go) source code, simplifying the build process and configuration. [3eb66541](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/3eb66541d4f19d5ae7d341af090290a2489177f7)

## [1.10.0] - 2020-02-21

### Added

- Introduced a Kubernetes deployment for a package manager application, including a database service and a frontend service, with configuration and secrets managed through a kustomization file, and utilizing persistent volume claims and hostPath volumes for storage. [b24c4d34](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/b24c4d348c88c556fd8069d8d437c65d4cb807a1)

## [1.9.14] - 2020-02-14

### Changed

- Simplified the local deployment process by introducing a script that automates server installation and configuration, and a new `install` target was added to the Makefile to streamline the deployment workflow. [bad8263e](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/bad8263eb939ea3abb40cd1222c39e09c1e4c218)

## [1.9.13] - 2020-02-11

### Changed

- The server application has been modernized to initialize the database separately from handling API requests. [314ad2b8](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/314ad2b85d23c3e4706635c235979fbd86effbbf)

## [1.9.12] - 2020-02-10

### Changed

- The system now supports dynamic package repository updates based on the operating system, enabling developers to request updates without manual intervention. [68f1a53b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/68f1a53b4d4ab9d18cd90a09e0ac00606bda059d)

## [1.9.11] - 2020-02-06

### Changed

- The `GetScript` method now returns a more compact representation of the script, while the `CreateScript` method returns the created script object, enabling easier handling of script data. [34b074e9](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/34b074e9d24f50d0fc07b75293e9449edd96423c)

## [1.9.10] - 2020-02-03

### Changed

- Enabled more flexible and feature-rich logging behavior in the application by switching from the standard Go log package to the logrus module. [caadde7b](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/caadde7bdb76bc7bb5ae0d62b0ae7536daab15a1)

## [1.9.9] - 2020-02-03

### Changed

- Scripts are now referenced from an external directory, eliminating the need for the scripts folder within the repository. [ceffd199](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/ceffd1995eb534b8778995191b4830a551394797)

## [1.9.8] - 2020-02-02

### Changed

- Updated the list of supported Linux distributions to reflect the latest available versions, bumping clearlinux, centos_7, ubuntu_bionic, centos_8, and opensuse version numbers without affecting the API or CLI contract, and without introducing any security risks. [5d3c8186](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5d3c8186a222469a94980a900aa1ff44ff27cc8a)

## [1.9.7] - 2020-02-02

### Changed

- Modernized the deployment setup to use Docker and Docker Compose, enabling flexible and scalable deployment configurations with support for both SQLite and MySQL/MariaDB databases. [442aba5d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/442aba5dec809b5034426c6e33f1444c85595fc0)

## [1.9.6] - 2020-02-02

### Changed

- Updated the vagrant setup to use the latest version, 2.2.7, ensuring users have the most current vagrant installed. [433896ff](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/433896ffa8badffbd67a08d4f55bc0b77f25542e)

## [1.9.5] - 2020-02-02

### Changed

- Enabled the creation of a containerized version of the package manager through the addition of a Dockerfile, allowing users to build and run the application using Docker commands without affecting existing Makefile commands. [c7383394](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c7383394ccc46949df4a1ab4b880f94e5d62bd25)

## [1.9.4] - 2020-02-02

### Changed

- Scripts are now located in a new directory and users must update their scripts to point to the new location. [9b70549d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/9b70549da670239fd20d5bc5a64c088d0f50f646)

## [1.9.3] - 2020-01-30

### Changed

- The Go API for the local server now supports the management of Bash scripts for package installations on various Linux distributions, providing a get script operation that returns a Bash script based on the provided package name. [a0068cc7](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a0068cc784305e4a38ef0dfa4cf3a4c8c501f548)

## [1.9.2] - 2020-01-24

### Changed

- The minimum required Python version for the pip installation process has been modernized to 3.5. [e3a49b69](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e3a49b69cb0daed19cfc30bd21e8b24d5448f0d1)

## [1.9.1] - 2020-01-22

### Changed

- Updated the distros_supported list to reflect the latest versions for supported Linux distributions. [5c086fa1](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5c086fa179732798cc289fa92bec5bf7117ccea0)

## [1.9.0] - 2020-01-22

### Added

- Enabled installation of packages with python-devel dependencies on Suse, RedHat, and ClearLinux platforms. [c69f0def](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c69f0def6eb8fcb54779ebe23783b8ac54fbf8d2)

## [1.8.0] - 2020-01-21

### Added

- Enabled support for RedHat systems to install packages from the Extra Packages for Enterprise Linux repository, enhancing package management capabilities for users on these systems. [51a87e9f](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/51a87e9fe6aa001d5eb5557fea62aaa3838ae75e)

## [1.7.1] - 2020-01-21

### Changed

- Enabled pip package management for Python projects by including a pip installation script in the project, which can be used to install pip on systems where it is not available by default, affecting systems including Suse, Debian, RedHat, and ClearLinux. [4cc704e1](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/4cc704e1daf1bbcb59094f4e8b3eef2626aad39f)

## [1.7.0] - 2020-01-02

### Added

- Terraform can now be installed through a script that supports various package managers and operating systems. [7d631840](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/7d6318407eecb657792c7606c28d6bfa26f37729)

## [1.6.0] - 2019-12-27

### Added

- Introduced support for VirtualBox installations, enabling users to deploy the project on various operating systems including Debian, RedHat, and ClearLinux without requiring any migration steps or changes to the API or CLI contract. [f9f25105](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f9f25105c488f12ca80d5b57a727b3deb5cb41e4)

## [1.5.1] - 2019-12-13

### Changed

- Standardized distributions' support to a centralized list stored in a single YAML file, which now drives Vagrant environment configurations across the project. [e4fdc744](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/e4fdc744b0630f64480396a1fc13ac5014c50063)

## [1.5.0] - 2019-12-13

### Added

- Installation of the system can now be performed using Ansible as a supported package manager. [cf884ce2](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/cf884ce21e8a81ae2d0d7ce5f73dce65bcdd0ccb)

## [1.4.0] - 2019-12-13

### Added

- Enabled users to install Vagrant on various Linux distributions, including Ubuntu, CentOS, ClearLinux, and openSUSE, with automated package management and validation. [c4bbba5d](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/c4bbba5db03e04a1f7ffea431fc9e2f0fabf9fdc)

## [1.3.0] - 2019-12-13

### Added

- Docker installations now automatically handle the installation of the containerd.io dependency for supported Linux distributions. [a834c8f6](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/a834c8f6dff127c7994b5c573151bd87472705e4)

## [1.2.1] - 2019-12-13

### Changed

- Tests are now more reliable and accurate due to improved test scripts that check for package installation and version availability before proceeding. [f68d5e75](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/f68d5e75644be771de6404b81d8c6c6ec52a3d2b)

## [1.2.0] - 2019-12-13

### Added

- The Docker chameleonsocks script now depends on the wget package, which is installed if it is not already present, and users who run the script without wget installed must install it before proceeding. [d93fae96](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/d93fae966006983b3cc7e4af3065fced66cbac24)

## [1.1.3] - 2019-12-13

### Changed

- Docker insecure registries configuration is now customizable through a package variable, allowing users to easily manage their setup. [5803a6cb](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/5803a6cb7897bf8896ee41efcf95b64416f460de)

## [1.1.2] - 2019-12-13

### Changed

- pip is now the recommended package manager on Debian and RedHat distributions, and the installation script will automatically install it if necessary for certain packages. [49aca712](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/49aca71206f5e397c2e116f23e4b084669e41101)

## [1.1.1] - 2019-12-13

### Changed

- Enabled support for openSUSE, allowing users to run the tool on this Linux distribution without introducing any breaking behavior or API changes. [01af10cb](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/01af10cbe1db8977a1783784ef4a1c271fba05d5)

## [1.1.0] - 2019-12-13

### Added

- Enabled support for the Go programming language, allowing developers to install and validate Go environments through a Vagrantfile, main.sh script, and validate.sh script, with corresponding updates to the install.sh script for Go package management. [58217b26](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/58217b26dea38b78b252c0aec6a740f63970770c)

## [1.0.1] - 2019-11-08

### Changed

- Enabled simultaneous package installation, allowing users to install multiple dependencies with a single command without introducing breaking behavior or migration requirements. [97a222e5](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/97a222e5e55a4f3cfcdfed0970df7535a50d043a)

## [1.0.0] - 2019-11-05

### Added

- Enabled a package manager for Linux projects, simplifying the installation and configuration of various packages across different distributions with support for Docker, OpenJDK, and Vim. [53a0be94](https://github.com/electrocucaracha/pkg-mgr_scripts/commit/53a0be9453240b5b383c12b26372ed86e8f852da)

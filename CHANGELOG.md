# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

* Bootstrap script url for buildkite runners

### Changed
### Deprecated
### Removed
### Fixed
### Security

## [1.0.0] - 2018-05-01

### Added

* Add runners_agents_per_instance variable [#49](https://gitlab.hq.nulogy.com/Nulogy/nulogy-deployer/merge_requests/49)

### Changed

* Move creation of secret bucket outside of nulogy deployer [#49](https://gitlab.hq.nulogy.com/Nulogy/nulogy-deployer/merge_requests/49)

### Deprecated
### Removed

* Remove `tg_aws.sh` utility script [#49](https://gitlab.hq.nulogy.com/Nulogy/nulogy-deployer/merge_requests/49)

### Fixed

 * Clean up postgres config (Evan Brodie) [#47](https://gitlab.hq.nulogy.com/Nulogy/nulogy-deployer/merge_requests/47)
 
### Security

## [0.13.0] - 2018-04-26

### Added

* Adds tg_aws.sh utility to make it easier to run aws commands with the right profile and region

## [0.12.0] - 2018-04-26

### Changed

* Adds ECR Lifecycle policy to ECR module that keeps newest 100 images only

## [0.11.4] - 2018-04-23

### Changed

* tg_deploy.sh, tg_prepare.sh, tg_setup.sh and tg_teardown.sh are updated to properly handle resources and 
not just modules

## [0.11.3] - 2018-04-20

### Removed

* buildkite elastic ci stack: Move ECR build repo out of the module group

## [0.11.2] - 2018-04-20

### Fixed

* Make stack_ami_version an optional variable in elastic_ci_stack module group

## [0.11.1] - 2018-04-20

### Added

* A `stack_ami_version` variable for the buildkite stack

## [0.11.0] - 2018-04-19

### Added

* Module for buildkite elastic stack

### Changed

* Upgrade terraform from 0.11.1 to 0.11.7
* Upgrade terragrunt from 0.13.23 to 0.14.7

### Removed

* Move Terraform code in `apps` to their app repos

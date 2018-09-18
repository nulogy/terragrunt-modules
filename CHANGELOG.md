# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
### Changed
* Change event_shovel module group and event_shovel_ecs_service module to allow evaluation_periods to be variable

### Deprecated
### Removed
### Fixed
### Security

## [2.1.3] - 2018-09-07

### Added

* Add optional Buildkite server size parameter to allow cutting the size for cost savings.

## [2.1.2] - 2018-09-07

### Added

* Add optional stickiness header for CSS/JS.

## [2.1.1] - 2018-08-23

### Fixed

* Fixed an issue where lambdas and iam roles for ECS clusters were colliding since they weren't namespaced

## [2.1.0] - 2018-08-23

### Added

* Added the event_shovel module group

### Changed

* ECS modules & module groups no longer support the `skip` variable. It was causing issues with terraform interpolation and wasn't actually used anywhere.

## [2.0.0] - 2018-08-21

### Changed

* Changed how ecs_auto_scaling_group works, to handle AMI / Launch Configuration changes gracefully without container downtime.

## [1.9.0] - 2018-08-14

### Added

* Added ECS environment variables to support ECS metadata access from within the container

## [1.8.0] - 2018-08-14

### Added

* Added builder_min_size, builder_scale_up_adjustment and builder_scale_down_adjustment optional variables to elastic_ci_stack module group
* Added scaled_down_adjustment and scale_up_adjustment to buildkite_elastic_stack module

## [1.7.0] - 2018-07-30

### Added
* Add module for building and deploying a RabbitMQ cluster
* Additional configuration for elastic ci stack builders

## [1.6.0] - 2018-06-19

### Changed

* Output ECS autoscaling group name to make autoscaling easier.
* Allow overriding default_cooldown for autoscaling rules.
* Ignore changes on the desired_capacity, so it doesn't revert after autoscaling.

## [1.5.0] - 2018-06-12

### Changed

* Allow using buildkite_elastic_stack with a bootstrap script policy.
* Change the pathing for modules to allow apps to use subfolders in their directory structure.

## [1.4.0] - 2018-05-28

### Changed

* Switch the placement strategy for ECS containers to spread by availability zone.

## [1.3.0] - 2018-05-25

### Added

* Make the creation of `aws_ecr_lifecycle_policy` optional

### Changed

* Decouple `buildkite_queue` from `buildkite_env_name` so we can support blue/green deployments of buildkite stack

## [1.2.0] - 2018-05-24

### Added

* Add an optional profile parameter to the cloudfront module. Backwards compatible.

## [1.1.0] - 2018-05-18

### Added

* Add a builder_bootstrap_script_url to the elastic_ci_stack module

### Changed

* Add support for v3.2 of the buildkite AWS stack

## [1.0.3] - 2018-05-14

### Changed

Moves the docker repository from ECR to our publicly hosted Docker Hub repo.

## [1.0.2] - 2018-05-02

### Added

* Add a security group to buildkite stack so only office ip can SSH to it
* Add output for runners_vpc_id, runners_public_subnet_ids and runners_security_group_id for the Buildkite stack

## [1.0.1] - 2018-05-02

### Added

* Bootstrap script url for buildkite runners

## [1.0.0] - 2018-05-01

### Added

* Add runners_agents_per_instance variable [#49](https://gitlab.hq.nulogy.com/Nulogy/nulogy-deployer/merge_requests/49)

### Changed

* Move creation of secret bucket outside of nulogy deployer [#49](https://gitlab.hq.nulogy.com/Nulogy/nulogy-deployer/merge_requests/49)

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

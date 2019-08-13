# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added

* Adds variable for `command` for ecs_service module container task definitions

### Changed

* Uses a template file to configure ecs_service module container task definitions

### Deprecated
### Removed
### Fixed
### Security

## [7.6.0] - 2019-08-14

### Added

* Adds parameter `scale_down_period` to the "buildkite_elastic_stack" module

### Changed
### Deprecated
### Removed
### Fixed
### Security

## [7.5.0] - 2019-08-08
    
### Added

* Adds additional terraform providers.


## [7.4.0] - 2019-07-30
    
### Added

* Adds support for an extra security ingress to ECS Cluster. Defaults to 127.0.0.0/8 CIDR, port 65535 and UDP protocol.

## [7.3.0] - 2019-07-17

### Added

* Adds NAT Gateway public IPs as an output

## [7.2.0] - 2019-07-16
    
### Added

Added Buildkite Agent Timestamp Lines (BuildkiteAgentTimestampLines)

### Removed

Removed `stack_ami_version` variable for buildkite_elastic_stack module since it's not used

## [7.1.2] - 2019-05-31
    
### Added

* Adds missing deployer permissions
    
## [7.1.1] - 2019-05-30

### Added

* Outputs ecs private subnets for fargate event shovel
    
## [7.1.0] - 2019-05-30

### Changed

* Uses skip variable for ecr lifecycle policy

### Removed

* Removes code for rolling upgrades of ECS AMIs

### Fixed

* Changes cache_behaviour to ordered_cache_behaviour as cache_behaviour was removed in AWS provider version 2

## [7.0.1] - 2019-05-24

### Changed

* Public load balancer target group considers HTTP 301 (redirect) as a healthy response. This allows `config.force_ssl` to be set as true in Rails.

## [7.0.0] - 2019-05-06

### Changed

* Updates terraform, terragrunt and landscape.  Avoids re-downloading the aws provider.

## [6.4.3] - 2019-04-10

### Changed

* Sets the TERRAGRUNT_DOWNLOAD environment variable to /root/.terragrunt. This prevents the host's filesystem from getting cluttered with .terragrunt-cache directories.

## [6.4.2] - 2019-03-28

### Fixed

* Fixes the priority values in order to avoid collisions on LBs routing rules during the terraform deployment.

## [6.4.1] - 2019-03-27

### Fixed

* Fixes the default status code (503) for maintenance pages managed by AWS Load Balancer.

## [6.4.0] - 2019-03-26

### Changed

* Adds support to maintenance pages on AWS Load Balancer level by means of 'aws_lb_listener_rule'. It can serve static content (Plain Text/HTML) content up to 1024 bytes.

## [6.3.1] - 2019-03-01

### Changed

* Adds ssm:GetParameters permission to every role that was using ssm:GetParameter.  Shockingly, these are two 
permissions different.

## [6.3.0] - 2019-02-28

### Changed

* Allow configuring alerting threshold for event_shovel.

## [6.2.0] - 2019-02-13

### Changed

* Allow passing in stickiness header to Fargate with Load Balancer.

## [6.1.0] - 2019-02-08

### Changed

* The nulogy deployer version is shown in the shell prompt.

## [6.0.0] - 2019-02-04

### Changed

* ECS fargate with elb module no longer hardcodes the security group name to "PackManager App Workers".
  * Existing users of this module can set `security_group_name = "PackManager App Workers"` to avoid downtime changes.

## [5.0.0] - 2019-01-25

### Changed

* Moved Event Shovel from EC2 servers to Fargate.

* Required variables: "private_subnet_ids", "vpc_id" for Fargate support.

## [4.3.3] - 2019-01-23

### Updated

* ECR now has better default rules.
* ECR No longer relies on prefix tag to apply lifecycle policy.
* ECR variable `count_cap_tag_prefix` is now deprecated.

## [4.3.2] - 2019-01-22

### Added

* Added slow_start option.

## [4.3.1] - 2019-01-15

### Added

* Added ssm:PutParameter permission to Fargate clusters

## [4.3.0] - 2019-01-14

### Added

* Added log_group_arn output to Fargate.

## [4.2.1] - 2019-01-09

### Added

* Added log_group output to Fargate with ECS and a load balancer Module to allow shipping logs from Cloudwatch.

## [4.2.0] - 2019-01-02

### Added

* Added Module for Fargate with ECS and a load balancer.

### Updated

* Adds missing permissions to the CI Pipeline Policy Document: `ecr:ListTagsForResource`

## [4.1.2] - 2018-12-06

* Bug fix

## [4.1.1] - 2018-12-06

* Changes ecs_service_fargate to use a json file, allowing multiple configurations

## [4.1.0] - 2018-11-06

### Changed

* Upgrade terragrunt from 0.14.7 to 0.17.1

## [4.0.0] - 2018-10-25

### Removed

* Module group "elastic_ci_stack" has been deleted as it made too many assumptions and is no longer used

### Changed

* Module "buildkite_elastic_stack" has been modified to take a vpc and subnet to allow more flexibility

## [3.4.0] - 2018-10-25

### Added

* Allow adding more to ECS service IAM role via output.

## [3.3.0] - 2018-10-24

### Added

* Elastic_ci_stack builders can now specify a spot price.

## [3.2.0] - 2018-10-22

### Added

* Added command variable to Fargate ECS module in order to allow the same container to be used for multiple purposes
* Added health_check variable to Fargate ECS module

## [3.1.2] - 2018-10-16

* Uses cluster name instead of environment name to avoid name collision between ECS clusters on the same environment

## [3.1.1] - 2018-10-16

* Fix bug with passing in Security Groups to Fargate module.

## [3.1.0] - 2018-10-15

* Fargate support.
* Support for Fargate ECS Service with no load balancer (e.g. Background workers).

## [3.0.1] - 2018-10-11

### Added

* ECR module outputs name now.

## [3.0.0] - 2018-10-09

### Changed

* Must pass in full string for AMI lookup now.
* For example, "2018.03.g" -> "amzn-ami-2018.03.g-amazon-ecs-optimized"

### Added

* Allow different owner for AMI lookup. Defaults to Amazon.

## [2.2.0] - 2018-09-27

### Fixed

* Fix conflict between autoscaling cluster and rollingupdate cluster.

## [2.1.5] - 2018-09-20

### Added

* Added a variable to customize root volume size of buildkite builders

## [2.1.4] - 2018-09-19

### Added

* Moved hardcoded evaluation_periods to be a variable on event_shovel module group and event_shovel_ecs_service module

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

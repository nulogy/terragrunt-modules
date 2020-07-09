# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security

## [12.2.0] - 2020-07-08

### Changed

* Renamed output in ecs_service_fargate from iam_id to task_role_id output

### Deprecated

* ecs_service_fargate.iam_id output

### Removed

* ecs_plb_platform module
* write access to param store for ecs service

## [12.1.1] - 2020-07-08

### Fixed

* Selects most recent ACM certificate when there are more than one eligible, instead of crashing

## [12.1.0] - 2020-07-03

### Added

* Marks the deployments using Datadog
* Resizes Airbrake panel on Datadog
* Adds the Service Events panel

## [12.0.0] - 2020-06-30

### Removed

* buildkite_elastic_stack no longer takes the office ip and insteads allows traffic from the VPN

## [11.7.1] - 2020-06-30

### Fixed

* Removed warning threshold as it has no difference in paging as the alert threshold.

## [11.7.0] - 2020-06-30

### Added

* Added datadog module capable of creating dashboards and monitors.

## [11.6.0] - 2020-06-24

### Added

* Added a data-only module for getting networking information about the Shared VPC 

## [11.5.0] - 2020-06-23

### Changed

* Load Dadadog api key from parameter store
* Added Datadog env variable `DD_ENV`
* Added Datadog version variable `DD_VERSION`

## [11.4.1] - 2020-06-18

### Fixed

* ECS service fargate task definition path

## [11.4.0] - 2020-06-15

### Added

* Output for instance_role_name of buildkite stack

## [11.3.3] - 2020-06-10

### Fixed

* Injects `DATADOG_SERVICE` env var into the app (feature flag for initializer)

## [11.3.2] - 2020-06-10

### Fixed

* Add service name to Datadog agent tagging of a ECS Fargate task

## [11.3.1] - 2020-06-05

### Fixed

* Improves Datadog agent tagging of ECS Fargate task

## [11.3.0] - 2020-06-03

### Added

* Added `account_data` module

## [11.2.0] - 2020-06-03

### Added

* Add option to enable Datadog agent sidecar/replica container for the `ecs_fargate_with_elb` module group
* Added Datadog agent container task definition to `ecs_service_fargate_elb` module
* Added additional permission to Fargate task role policy to allow Datadog agent to perform autodiscovery.
* When upgrading your application, please apply these changes using nulogy-deployer locally before doing a deploy because Buildkite role does not have permissions to change task role policy:

```
cd app_worker
terragrunt plan -var docker_image=<YOUR_CURRENT_DEPLOYED_GIT_HASH>
```

## [11.1.0] - 2020-05-28

### Added

* Add option to enable `containerInsights` for the `ecs_cluster` module

## [11.0.0] - 2020-05-13

### Removed

* Removed `cloudfront_s3` module group, `cloudfront` module, and `ecs_service` module
  * these were copied to the GO project repository (the only project that was using it) for easier maintainability

### Security

* Updated the `ssl_policy` of the `public_load_balancer` to use only TLSv1.2

## [10.0.0] - 2020-05-11

### Changed

* Remove ignore_changes from the ecs_fargate modules. This was used for autoscaling, though blocks non-autoscaling usage. Autoscaled support will need to be added properly in the future.

## [9.0.0] - 2020-05-04

### Added

* Added an internal option for load balancers

### Changed

* Extracted the terragrunt modules to their own repo

### Removed

* Removes `cd_pipeline` module

### Fixed

* Fixes routes in vpc peering after upgrading to Terraform 0.12
* Fixes deprecation warning for `aws_lb_listener_rule.conditions` usage after upgrading aws provider to v2.59.0

### Security

## [8.22.0] - 2020-05-01

### Changed

* Migrates `aws_lb_listener_rule.conditions` in `public_load_balancer` to new syntax since the old one was deprecated on v2.42.0 of the AWS provider

### Fixed

* Moves dockerignore file to docker build context root
* Fixes routes in vpc peering after upgrading to Terraform 0.12

## [8.21.0] - 2020-04-17

### Changed

* Bumps terragrunt

## [8.20.0] - 2020-04-13

### Changed

* Removes custom terraform-provider-aws because the bugfix from 8.19.0 got merged into the mainline
* Bumps terragrunt

## [8.19.0] - 2020-04-06

### Changed

* Updates the AWS terraform provider to fix a bug with creating RDS read replicas in shared VPCs
* Moves the Dockerfile to the root dir for more flexibility

## [8.18.0] - 2020-04-03

### Changed

* The auth script now looks for the first occurrence of 'nulogy-account-name' in your path rather than the last.

## [8.17.0] - 2020-03-30

### Added

* ecs_incoming_allowed_cidr variable to ecs_fargate_with_elb.  Useful for VPC Tunnels.

## [8.16.0] - 2020-03-30

### Changed

* Bumps Terraform and Terragrunt versions.  Uses AWS Terraform provider 2.55.0 which fixes bug with restoring snapshots in shared VPCs.

## [8.15.0] - 2020-02-28

### Changed

* Adds the `lb_listener_arns` output to the `ecs-fargate-with-elb` module

## [8.14.0] - 2020-02-25

### Changed

* Bumps Terraform (0.12.21) and Terragrunt (0.22.4) versions

## [8.13.0] - 2020-02-25

### Added

* Adds the `lb_cert_arn` variable to the "ecs_service_fargate_elb" module

## [8.12.0] - 2020-01-22

### Added

* Adds the `health_check_command` variable to the "ecs_service_fargate_elb" module

## [8.11.0] - 2020-01-20

### Added

* empty_s3_bucket.sh script to help delete versioned s3 buckets

## [8.10.0] - 2020-01-20

### Changed

* Bumps Terraform and Terragrunt versions

## [8.9.1] - 2020-01-16

### Changed

* Bugfix for tgprep

## [8.9.0] - 2020-01-16

### Changed

* Terragrunt apply-all, plan-all and destroy-all aliases now work with symlink style modules.

## [8.8.3] - 2020-01-16

### Changed

* setup_auth.sh now shows your values as you paste them.

## [8.8.2] - 2020-01-15

### Changed

* auth.sh now caches account names for performance.

## [8.8.1] - 2020-01-10

### Changed

* auth.sh now uses the nulogy-anchor account to discover account names.

## [8.7.0] - 2020-01-07

### Added

* auth.sh now automatically checks if you are in an aws account directory and uses that if the command line parameter hasn't been set.

## [8.6.0] - 2019-12-20

### Added

* auth.sh and setup_auth.sh scripts which make it easy for users to login to the nulogy-auth account.

## [8.5.0] - 2019-12-12

### Added

* `ecs_fargate_with_elb` now outputs `ecs_service_name`

## [8.4.0] - 2019-12-11

### Added

* yq (https://yq.readthedocs.io/en/latest/)

## [8.3.0] - 2019-12-09

### Added

* `/deployer/utils/empty.hcl` placeholder for Terragrunt when you with to optionally include a file.
* `/deployer/utils/replace_terragrunt_hcl_with_symlinks.sh` Replaces regular environment hcl files with symlinks.

## [8.2.0] - 2019-11-29

### Added

* Adds optional `security_group_ids` to `public_load_balancer` module

## [8.1.0] - 2019-11-27

### Added

* Office IP var to the ecs_plb_platform module group
* Adds aliases for Terragrunt `tg=terragrunt`, `tga=terragrunt apply`, `tgpa=terragrunt plan-all`, etc...

### Changed

* Bump Terraform and Terragrunt versions

## [8.0.8] - 2019-10-10

* Updates default Nulogy office IP address

## [8.0.7] - 2019-10-03

### Changed

* Fixes security group for Public Load Balancer ipv6 support

## [8.0.6] - 2019-10-03

### Changed

* Public load balancer now supports ip_address_type "dualstack" for ipv6 support

## [8.0.5] - 2019-09-17

### Changed

* Bump Terraform and Terragrunt versions

## [8.0.4] - 2019-09-10

### Added

* Added variable to set mutability behaviour on ECRs
* Added experimental lambda based autoscaling variable to buildkite stack

### Fixed

* Fixed lifecycle syntax for buildkite stack after upgrading to terraform 0.12

## [8.0.3] - 2019-09-05

### Changed

* Bump Terraform and Terragrunt versions

## [7.8.0] - 2018-09-05

### Added

* Added health_check_timeout variable to the ecs_fargate_with_elb and to the public_load_balancer modules
* Added deregistration_delay variable to the ecs_fargate_with_elb and to the public_load_balancer modules to speed up deployments on some environments

### Removed

* Removed HTTP 301 (redirect) as a healthy response for the load balancer target group.

## [8.0.2] - 2019-09-05

### Changed

* Adds local provider to Dockerfile
* Fixes bug in modules/public_private_subnets/outputs.tf and modules/private_subnets/outputs.tf

## [8.0.1] - 2019-09-03

### Changed

* Bug fix for modules/ecs_service_fargate.  Depends_on is a reserved name in terraform 0.12.

## [8.0.0] - 2019-08-30

### Changed

* Upgrades to Terraform 0.12.7 and Terragrunt 0.19.21.
* Updates modules to Terraform 0.12 format

To migrate a project's modules, run: `find ./* -type d -maxdepth 0 -exec terraform 0.12upgrade -yes {} \;`
Convert terragrunt `terraform.tfvars` files in the environment root and module directories to `terragrunt.hcl`

### Removed

* Removes Terraform Landscape as it's no longer needed with Terraform 0.12

## [7.7.0] - 2019-08-15

### Added

* Adds variable for `command` for ecs_service module container task definitions

### Changed

* Uses a template file to configure ecs_service module container task definitions (no API change)

## [7.6.0] - 2019-08-14

### Added

* Adds parameter `scale_down_period` to the "buildkite_elastic_stack" module

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

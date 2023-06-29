# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres
to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

* Allows customizing default cache behavior

## [23.11.0] - 2023-06-27

* Adds `waf` module
* Fixes `cloudfront` module 

## [23.10.0] - 2023-05-30

### Added

* Adds `cloudfront` module with the option to set `web_acl_id` with WAF configuration
* Generalizes pattern used on different systems for consistency
* Fixes [configuration changes](https://github.com/hashicorp/terraform-provider-aws/issues/28353) to bucket ACLs introduced by AWS on April, 2023

## [23.8.0] - 2023-03-27

### Removed

* Removed `launch_type` attribute from `ecs_service`

## [23.7.0] - 2023-03-27

### Added

* Added support for ECS capacity provider. Defaults to `FARGATE`.

## [23.4.0] - 2023-01-05

### Added

* Added `image_lifecycle_count` key to control ECR replication counts

## [23.3.0] - 2023-01-05

### Added

* Added `kms_multi_region_key` to be used initially by `helm_secrets` module to encrypt/decrypt secrets using a KMS key that is highly available across primary and replica regions 

## [23.2.0] - 2022-05-04

### Added

* Added `access_log_bucket` and `access_log_prefix` variables to `ecs_fargate_with_elb` & optional `access_logs` to `public_load_balancer`

This allows access logs to be enabled for public load balancers.

## [23.1.0] - 2022-02-15

### Changed

* `snowflake_connector_config` exposes more variables for customization

## [23.0.0] - 2021-12-14

### Changed

* `kafka_connect_cluster` renamed the `kafka_bootstrap_servers` to `kafka_bootstrap_brokers`

### Added

* Added `additional_envars` to `kafka_connect_cluster`

This allows creating environment variables to configure Kafka Connnect.


## [22.3.0] - 2021-11-28

### Added

* Opinionated LaunchDarkly module that works in tandem with the Nulogy
  `feature_flagging` gem

## [22.2.0] - 2021-11-19

### Changed

* `buildkite_elastic_stack` now supports receiving an `instance_role_name` variable to explicitly set the Cloudformation `InstanceRoleName` needed to specify the name of the IAM role auto-created by the Cloudformation stack.

## [22.1.1] - 2021-11-19

### Fixed

* Allow multiple Buildkite queues per account by assuring that agent token SSM name and Cloudformation stack names are unique

## [22.1.0] - 2021-11-15

### Added

* Added `snowflake_connector_config` module to configure Kafka Connect Connector for Snowflake

### Changed

* Added input parameter `kafka_connect__docker_image_name` to
  `kafka_connect_cluster` module to allow different Kafka Connect Connectors
  to be run.  This change is backwards compatible, as Debezium 1.6.2 is used
  as a default.

## [22.0.1] - 2021-11-12

### Changed

* ECS service fargate modules expose the task execution role ID so
  that additional policies can be attached
* ECS service fargate autoscaling module exposes the container name as an output
* ECS service fargate autoscaling module provides the container name template
  variable for the task definition JSON file

## [22.0.0] - 2021-11-08

### Changed

* ECS service autoscaling fargate modules are configured to work with service
  discovery by default
* ECS service autoscaling fargate modules are configured to
  allow `enable_execute_command`

### Removed

* Removed service discovery configuration from CodeDeploy ECS module since it is
  not being used at the moment. It is not necessary for CodeDeploy based ECS
  tasks to communicate with other ECS services through service discovery.

## [21.1.0] - 2021-11-08

### Added

* Added module `kafka_connect_cluster` for starting an isolated set of ECS tasks
  for each Kafka Connect service (e.g. Debezium for Message Bus in OpsCore NA)

## [21.0.0] - 2021-11-02

### Added

* Added variable `subscription_events_ttl` to `debezium_config` defaulting to
  seven days (to match Message Bus Kafka topic deletion policy).
* Added variable `postgres_search_paths` to `debezium_config` to modify the
  Postgres `search_path` when executing heartbeats.

### Removed

* Removed the `heartbeat_query` variable from `debezium_config`.

## [20.3.0] - 2021-10-28

### Changed

* Allow overriding the Postgres replication slot name when configuring Debezium

## [20.2.1] - 2021-10-27

### Changed

* Use the same `us-east-1` region for reaching the Logz.io listener

## [20.2.0] - 2021-10-27

### Changed

* Upgrade the CloudWatch Logz.io log shipping lambda module to Python 3.7

## [20.1.0] - 2021-10-27

### Added

* ECS service discovery to `ecs_cluster`

### Changed

* ECS service fargate modules are configured to work with service discovery by
  default
* ECS service fargate modules are configured to allow `enable_execute_command`

## [20.0.0] - 2021-10-25

### Changed

* Upgrade Buildkite CI Stack to 5.7.1
* Store Buildkite agent token in parameter store. A KMS key is required to
  encrypt the parameter store.
* More sensible defaults in `buildkite_elastic_stack` variables.tf

### Security

* Buildkite instances have no public IP by default
* Require Buildkite instances to use IMDSv2 for improved security usage of EC2
  metadata service

## [19.2.0] - 2021-10-21

### Added

* Added optional field to `ecs_fargate_with_elb` and `ecs_service_fargate_elb`
  to allow custom ECS service names

## [19.1.0] - 2021-10-04

### Added

* Added `data_platform_database_user` module for creating a Postgres user for
  data platform.

## [19.0.0] - 2021-08-05

### Changed

* Changed module variables in `debezium_connection` to separate additionoal SQL
  statements for granting and revoking the user

## [18.7.0] - 2021-08-05

### Added

* Added variable to run addtional SQL commands for `debezium_database_user`.

## [18.6.0] - 2021-08-02

### Added

* `cloudfront_s3_origin` module that can be used to set up an AWS CloudFront
  distribution pointing to an S3 bucket as the origin. Useful for setting up
  HTTPS redirects.
* `s3_redirect_bucket` module whose job is to provide a redirect to another URL.
* `cloudfront_s3_redirect` module group that utilizes the `cloudfront_s3_origin`
  and `s3_redirect_bucket` modules to perform a HTTPS redirect to another URL.

## [18.5.0] - 2021-08-02

### Added

* `ecs_service_fargate_codedeploy` module that uses AWS CodeDeploy for
  deployments.
* `public_load_balancer_blue_green` module that has two target groups called
  Blue and Green which are used for AWS CodeDeploy for deployments.
* `ecs_fargate_with_codedeploy` module group that uses AWS CodeDeploy for
  deployments and requires two target groups to be available called Blue and
  Green.

## [18.4.0] - 2021-07-22

### Added

* Added the zone_id output to the ecs_fargate_with_elb module group

## [18.3.2] - 2021-07-06

### Changed

* Uses the `depends_on` meta argument for `modules` on ECS service module to
  replace the existing workaround that was there

## [18.3.1] - 2021-07-06

### Changed

* Added `ssm:GetParametersByPath` permission to every role that was using
  `ssm:GetParameter`

## [18.3.0] - 2021-05-18

### Changed

* `cloudwatch_logzio` module also considers environment variables of the log
  shipping lambda when determining if it needs to apply any changes

## [18.2.0] - 2021-05-05

### Added

* `cloudwatch_logzio` module does not specify any providers or versions so that
  it is compatible with TF 0.13
* `cloudwatch_logzio` module takes the Logz.io API key as a parameter called:
  `logzio__api_key`

## [18.1.1] - 2021-02-25

### Fixed

* Updated `debezium_connection` to insert heartbeats when running TF and when
  connecting to a database.

This should ensure heartbeats properly start for databases that have no traffic.

## [18.1.0] - 2021-02-01

### Added

* `cloudwatch_logzio` module that can be used to send logs to Logz.io

## [18.0.0] - 2020-11-16

### Changed

* Updates `buildkite_elastic_stack` to be compatible
  with [elastic stack v5](https://github.com/buildkite/elastic-ci-stack-for-aws/releases/tag/v5.0.0)

## [17.2.0] - 2020-10-14

### Changed

* Allow kafka_topics to work with TF 0.13

## [17.1.0] - 2020-10-14

### Changed

* Allow vpc_peering to work with TF 0.13

## [17.0.1] - 2020-10-05

### Added

* Paramaterizes AssociatePublicIPAddress for the buildkite elastic stack module.

## [17.0.0] - 2020-10-05

### Added

* Changes the default heartbeat SQL to use the renamed database columns.

## [16.2.0] - 2020-10-05

### Added

* Added modules for apps to use to connect to the message bus as a
  producer. `debezium_connection` and `deebziucm_database_user`.

## [16.1.2] - 2020-08-31

### Added

* Added security groups variable to ecs_scheduled_task module

## [16.1.1] - 2020-08-10

### Added

* Exposes the cluster ARN from the ecs_cluster module & module_group outputs

## [16.1.0] - 2020-08-04

### Added

* Added variable `ecr_url` on the event_shovel module group to control which
  repository to pull EventShovel from. Defaults to CPI's shared internal repo

### Removed

* No longer creates an ECR repo for EventShovel.

## [16.0.0] - 2020-07-14

### Notes:

This was initially released in a branch as part of a bad merge. The tag has
since been corrected. AK.

### Changed

* Updates the VPC Peering to use the new version which updates the route tables
  and has a simpler API.

### Removed

* Removes a second VPC peering module that appeared to be incomplete

## [15.1.0] - 2020-07-17

### Added

* Add `kafka_topics` module so that Message Bus consumers can setup topics

### Changed

* Updates the VPC Peering to use the new version which updates the route tables.

### Removed

* Removes a second VPC peering module that appeared to be incomplete

## [15.0.0] - 2020-07-14

### Added

* Add task_role_id output to ecs_fargate_with_elb module

### Changed

* Rename iam_id output to task_role_id in ecs_service_fargate_elb

## [14.0.0] - 2020-07-13

### Added

* Add container_name output to ecs_service_fargate module

### Changed

* Migrated ecs_scheduled_task module to use fargate

## [13.1.0] - 2020-07-09

### Added

* ecs_service_fargate_autoscaling, which is a version of the module that ignores
  desired_count changes so it can remain compatible with AWS autoscaling rules

## [13.0.0] - 2020-07-09

### Changed

* Renamed output in ecs_service_fargate from iam_id to task_role_id output

### Deprecated

* ecs_service_fargate.iam_id output

### Removed

* ecs_plb_platform module
* write access to param store for ecs service

## [12.1.1] - 2020-07-08

### Fixed

* Selects most recent ACM certificate when there are more than one eligible,
  instead of crashing

## [12.1.0] - 2020-07-03

### Added

* Marks the deployments using Datadog
* Resizes Airbrake panel on Datadog
* Added the Service Events panel

## [12.0.0] - 2020-06-30

### Removed

* buildkite_elastic_stack no longer takes the office ip and insteads allows
  traffic from the VPN

## [11.7.1] - 2020-06-30

### Fixed

* Removed warning threshold as it has no difference in paging as the alert
  threshold.

## [11.7.0] - 2020-06-30

### Added

* Added datadog module capable of creating dashboards and monitors.

## [11.6.0] - 2020-06-24

### Added

* Added a data-only module for getting networking information about the Shared
  VPC

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

* Add option to enable Datadog agent sidecar/replica container for
  the `ecs_fargate_with_elb` module group
* Added Datadog agent container task definition to `ecs_service_fargate_elb`
  module
* Added additional permission to Fargate task role policy to allow Datadog agent
  to perform autodiscovery.
* When upgrading your application, please apply these changes using
  nulogy-deployer locally before doing a deploy because Buildkite role does not
  have permissions to change task role policy:

```
cd app_worker
terragrunt plan -var docker_image=<YOUR_CURRENT_DEPLOYED_GIT_HASH>
```

## [11.1.0] - 2020-05-28

### Added

* Add option to enable `containerInsights` for the `ecs_cluster` module

## [11.0.0] - 2020-05-13

### Removed

* Removed `cloudfront_s3` module group, `cloudfront` module, and `ecs_service`
  module
    * these were copied to the GO project repository (the only project that was
      using it) for easier maintainability

### Security

* Updated the `ssl_policy` of the `public_load_balancer` to use only TLSv1.2

## [10.0.0] - 2020-05-11

### Changed

* Remove ignore_changes from the ecs_fargate modules. This was used for
  autoscaling, though blocks non-autoscaling usage. Autoscaled support will need
  to be added properly in the future.

## [9.0.0] - 2020-05-04

### Added

* Added an internal option for load balancers

### Changed

* Extracted the terragrunt modules to their own repo

### Removed

* Removes `cd_pipeline` module

### Fixed

* Fixes routes in vpc peering after upgrading to Terraform 0.12
* Fixes deprecation warning for `aws_lb_listener_rule.conditions` usage after
  upgrading aws provider to v2.59.0

### Security

## [8.22.0] - 2020-05-01

### Changed

* Migrates `aws_lb_listener_rule.conditions` in `public_load_balancer` to new
  syntax since the old one was deprecated on v2.42.0 of the AWS provider

### Fixed

* Moves dockerignore file to docker build context root
* Fixes routes in vpc peering after upgrading to Terraform 0.12

## [8.21.0] - 2020-04-17

### Changed

* Bumps terragrunt

## [8.20.0] - 2020-04-13

### Changed

* Removes custom terraform-provider-aws because the bugfix from 8.19.0 got
  merged into the mainline
* Bumps terragrunt

## [8.19.0] - 2020-04-06

### Changed

* Updates the AWS terraform provider to fix a bug with creating RDS read
  replicas in shared VPCs
* Moves the Dockerfile to the root dir for more flexibility

## [8.18.0] - 2020-04-03

### Changed

* The auth script now looks for the first occurrence of 'nulogy-account-name' in
  your path rather than the last.

## [8.17.0] - 2020-03-30

### Added

* ecs_incoming_allowed_cidr variable to ecs_fargate_with_elb. Useful for VPC
  Tunnels.

## [8.16.0] - 2020-03-30

### Changed

* Bumps Terraform and Terragrunt versions. Uses AWS Terraform provider 2.55.0
  which fixes bug with restoring snapshots in shared VPCs.

## [8.15.0] - 2020-02-28

### Changed

* Added the `lb_listener_arns` output to the `ecs-fargate-with-elb` module

## [8.14.0] - 2020-02-25

### Changed

* Bumps Terraform (0.12.21) and Terragrunt (0.22.4) versions

## [8.13.0] - 2020-02-25

### Added

* Added the `lb_cert_arn` variable to the "ecs_service_fargate_elb" module

## [8.12.0] - 2020-01-22

### Added

* Added the `health_check_command` variable to the "ecs_service_fargate_elb"
  module

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

* Terragrunt apply-all, plan-all and destroy-all aliases now work with symlink
  style modules.

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

* auth.sh now automatically checks if you are in an aws account directory and
  uses that if the command line parameter hasn't been set.

## [8.6.0] - 2019-12-20

### Added

* auth.sh and setup_auth.sh scripts which make it easy for users to login to the
  nulogy-auth account.

## [8.5.0] - 2019-12-12

### Added

* `ecs_fargate_with_elb` now outputs `ecs_service_name`

## [8.4.0] - 2019-12-11

### Added

* yq (https://yq.readthedocs.io/en/latest/)

## [8.3.0] - 2019-12-09

### Added

* `/deployer/utils/empty.hcl` placeholder for Terragrunt when you with to
  optionally include a file.
* `/deployer/utils/replace_terragrunt_hcl_with_symlinks.sh` Replaces regular
  environment hcl files with symlinks.

## [8.2.0] - 2019-11-29

### Added

* Added optional `security_group_ids` to `public_load_balancer` module

## [8.1.0] - 2019-11-27

### Added

* Office IP var to the ecs_plb_platform module group
* Added aliases for Terragrunt `tg=terragrunt`, `tga=terragrunt apply`
  , `tgpa=terragrunt plan-all`, etc...

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

* Added health_check_timeout variable to the ecs_fargate_with_elb and to the
  public_load_balancer modules
* Added deregistration_delay variable to the ecs_fargate_with_elb and to the
  public_load_balancer modules to speed up deployments on some environments

### Removed

* Removed HTTP 301 (redirect) as a healthy response for the load balancer target
  group.

## [8.0.2] - 2019-09-05

### Changed

* Added local provider to Dockerfile
* Fixes bug in modules/public_private_subnets/outputs.tf and
  modules/private_subnets/outputs.tf

## [8.0.1] - 2019-09-03

### Changed

* Bug fix for modules/ecs_service_fargate. Depends_on is a reserved name in
  terraform 0.12.

## [8.0.0] - 2019-08-30

### Changed

* Upgrades to Terraform 0.12.7 and Terragrunt 0.19.21.
* Updates modules to Terraform 0.12 format

To migrate a project's modules,
run: `find ./* -type d -maxdepth 0 -exec terraform 0.12upgrade -yes {} \;`
Convert terragrunt `terraform.tfvars` files in the environment root and module
directories to `terragrunt.hcl`

### Removed

* Removes Terraform Landscape as it's no longer needed with Terraform 0.12

## [7.7.0] - 2019-08-15

### Added

* Added variable for `command` for ecs_service module container task definitions

### Changed

* Uses a template file to configure ecs_service module container task
  definitions (no API change)

## [7.6.0] - 2019-08-14

### Added

* Added parameter `scale_down_period` to the "buildkite_elastic_stack" module

## [7.5.0] - 2019-08-08

### Added

* Added additional terraform providers.

## [7.4.0] - 2019-07-30

### Added

* Added support for an extra security ingress to ECS Cluster. Defaults to
  127.0.0.0/8 CIDR, port 65535 and UDP protocol.

## [7.3.0] - 2019-07-17

### Added

* Added NAT Gateway public IPs as an output

## [7.2.0] - 2019-07-16

### Added

Added Buildkite Agent Timestamp Lines (BuildkiteAgentTimestampLines)

### Removed

Removed `stack_ami_version` variable for buildkite_elastic_stack module since
it's not used

## [7.1.2] - 2019-05-31

### Added

* Added missing deployer permissions

## [7.1.1] - 2019-05-30

### Added

* Outputs ecs private subnets for fargate event shovel

## [7.1.0] - 2019-05-30

### Changed

* Uses skip variable for ecr lifecycle policy

### Removed

* Removes code for rolling upgrades of ECS AMIs

### Fixed

* Changes cache_behaviour to ordered_cache_behaviour as cache_behaviour was
  removed in AWS provider version 2

## [7.0.1] - 2019-05-24

### Changed

* Public load balancer target group considers HTTP 301 (redirect) as a healthy
  response. This allows `config.force_ssl` to be set as true in Rails.

## [7.0.0] - 2019-05-06

### Changed

* Updates terraform, terragrunt and landscape. Avoids re-downloading the aws
  provider.

## [6.4.3] - 2019-04-10

### Changed

* Sets the TERRAGRUNT_DOWNLOAD environment variable to /root/.terragrunt. This
  prevents the host's filesystem from getting cluttered with .terragrunt-cache
  directories.

## [6.4.2] - 2019-03-28

### Fixed

* Fixes the priority values in order to avoid collisions on LBs routing rules
  during the terraform deployment.

## [6.4.1] - 2019-03-27

### Fixed

* Fixes the default status code (503) for maintenance pages managed by AWS Load
  Balancer.

## [6.4.0] - 2019-03-26

### Changed

* Added support to maintenance pages on AWS Load Balancer level by means of '
  aws_lb_listener_rule'. It can serve static content (Plain Text/HTML) content
  up to 1024 bytes.

## [6.3.1] - 2019-03-01

### Changed

* Added ssm:GetParameters permission to every role that was using ssm:
  GetParameter. Shockingly, these are two permissions different.

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

* ECS fargate with elb module no longer hardcodes the security group name to "
  PackManager App Workers".
    * Existing users of this module can
      set `security_group_name = "PackManager App Workers"` to avoid downtime
      changes.

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

* Added log_group output to Fargate with ECS and a load balancer Module to allow
  shipping logs from Cloudwatch.

## [4.2.0] - 2019-01-02

### Added

* Added Module for Fargate with ECS and a load balancer.

### Updated

* Added missing permissions to the CI Pipeline Policy
  Document: `ecr:ListTagsForResource`

## [4.1.2] - 2018-12-06

* Bug fix

## [4.1.1] - 2018-12-06

* Changes ecs_service_fargate to use a json file, allowing multiple
  configurations

## [4.1.0] - 2018-11-06

### Changed

* Upgrade terragrunt from 0.14.7 to 0.17.1

## [4.0.0] - 2018-10-25

### Removed

* Module group "elastic_ci_stack" has been deleted as it made too many
  assumptions and is no longer used

### Changed

* Module "buildkite_elastic_stack" has been modified to take a vpc and subnet to
  allow more flexibility

## [3.4.0] - 2018-10-25

### Added

* Allow adding more to ECS service IAM role via output.

## [3.3.0] - 2018-10-24

### Added

* Elastic_ci_stack builders can now specify a spot price.

## [3.2.0] - 2018-10-22

### Added

* Added command variable to Fargate ECS module in order to allow the same
  container to be used for multiple purposes
* Added health_check variable to Fargate ECS module

## [3.1.2] - 2018-10-16

* Uses cluster name instead of environment name to avoid name collision between
  ECS clusters on the same environment

## [3.1.1] - 2018-10-16

* Fix bug with passing in Security Groups to Fargate module.

## [3.1.0] - 2018-10-15

* Fargate support.
* Support for Fargate ECS Service with no load balancer (e.g. Background
  workers).

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

* Moved hardcoded evaluation_periods to be a variable on event_shovel module
  group and event_shovel_ecs_service module

## [2.1.3] - 2018-09-07

### Added

* Add optional Buildkite server size parameter to allow cutting the size for
  cost savings.

## [2.1.2] - 2018-09-07

### Added

* Add optional stickiness header for CSS/JS.

## [2.1.1] - 2018-08-23

### Fixed

* Fixed an issue where lambdas and iam roles for ECS clusters were colliding
  since they weren't namespaced

## [2.1.0] - 2018-08-23

### Added

* Added the event_shovel module group

### Changed

* ECS modules & module groups no longer support the `skip` variable. It was
  causing issues with terraform interpolation and wasn't actually used anywhere.

## [2.0.0] - 2018-08-21

### Changed

* Changed how ecs_auto_scaling_group works, to handle AMI / Launch Configuration
  changes gracefully without container downtime.

## [1.9.0] - 2018-08-14

### Added

* Added ECS environment variables to support ECS metadata access from within the
  container

## [1.8.0] - 2018-08-14

### Added

* Added builder_min_size, builder_scale_up_adjustment and
  builder_scale_down_adjustment optional variables to elastic_ci_stack module
  group
* Added scaled_down_adjustment and scale_up_adjustment to
  buildkite_elastic_stack module

## [1.7.0] - 2018-07-30

### Added

* Add module for building and deploying a RabbitMQ cluster
* Additional configuration for elastic ci stack builders

## [1.6.0] - 2018-06-19

### Changed

* Output ECS autoscaling group name to make autoscaling easier.
* Allow overriding default_cooldown for autoscaling rules.
* Ignore changes on the desired_capacity, so it doesn't revert after
  autoscaling.

## [1.5.0] - 2018-06-12

### Changed

* Allow using buildkite_elastic_stack with a bootstrap script policy.
* Change the pathing for modules to allow apps to use subfolders in their
  directory structure.

## [1.4.0] - 2018-05-28

### Changed

* Switch the placement strategy for ECS containers to spread by availability
  zone.

## [1.3.0] - 2018-05-25

### Added

* Make the creation of `aws_ecr_lifecycle_policy` optional

### Changed

* Decouple `buildkite_queue` from `buildkite_env_name` so we can support
  blue/green deployments of buildkite stack

## [1.2.0] - 2018-05-24

### Added

* Add an optional profile parameter to the cloudfront module. Backwards
  compatible.

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
* Add output for runners_vpc_id, runners_public_subnet_ids and
  runners_security_group_id for the Buildkite stack

## [1.0.1] - 2018-05-02

### Added

* Bootstrap script url for buildkite runners

## [1.0.0] - 2018-05-01

### Added

* Add runners_agents_per_instance
  variable [#49](https://gitlab.hq.nulogy.com/Nulogy/nulogy-deployer/merge_requests/49)

### Changed

* Move creation of secret bucket outside of nulogy
  deployer [#49](https://gitlab.hq.nulogy.com/Nulogy/nulogy-deployer/merge_requests/49)

### Removed

* Remove `tg_aws.sh` utility
  script [#49](https://gitlab.hq.nulogy.com/Nulogy/nulogy-deployer/merge_requests/49)

### Fixed

* Clean up postgres config (Evan
  Brodie) [#47](https://gitlab.hq.nulogy.com/Nulogy/nulogy-deployer/merge_requests/47)

### Security

## [0.13.0] - 2018-04-26

### Added

* Added tg_aws.sh utility to make it easier to run aws commands with the right
  profile and region

## [0.12.0] - 2018-04-26

### Changed

* Added ECR Lifecycle policy to ECR module that keeps newest 100 images only

## [0.11.4] - 2018-04-23

### Changed

* tg_deploy.sh, tg_prepare.sh, tg_setup.sh and tg_teardown.sh are updated to
  properly handle resources and not just modules

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

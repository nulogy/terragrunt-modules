## RabbitMQ Cluster

Use this module to build and deploy an autoclustering group of RabbitMQ servers.

To generate the AMI from which the cluster will be built:
* Download [Packer](https://www.packer.io/downloads.html) to `/usr/local/bin`
* `git clone git@gitlab.hq.nulogy.com:CN1/nulogy_rabbitmq_2.git`
* `cd ~/src/nulogy_rabbitmq_2`
* Use the `build_ami` script: `AWS_PROFILE=your_aws_profile_name build_ami`

These servers are intended to be immutable. If changes are required, a new AMI should be applied. 
The rules will do this in a rolling fashion.

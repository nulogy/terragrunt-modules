#!/usr/bin/env bash

export ENVIRONMENT_NAME="${environment_name}"
export AWS_REGION="${aws_region}"

# Set environment_name in the config for Rabbit.
sed -i -e "s/<# ENVIRONMENT_NAME #>/${environment_name}/g" /etc/rabbitmq/rabbitmq.conf
sed -i -e "s/<# AWS_REGION #>/${aws_region}/g" /etc/rabbitmq/rabbitmq.conf

# Grab secrets from SSM.
/usr/local/bin/add_secrets.sh

# Tell the Cloudformation policy we're done launching.
cfn-signal --stack "${environment_name}-RabbitMQ-autoscaling" --resource "RabbitMQAsg" --region ${aws_region}

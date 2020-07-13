variable "aws_region" {
  description = "The AWS Region you want to send everything to. Pick something close to the customer."
}

variable "aws_profile" {
  description = "The AWS account you want to use, as defined by your ~/.aws/credentials file."
}

variable "acceptor_account_id" {}

variable "acceptor_vpc_id" {}

variable "requester_account_id" {}

variable "requester_vpc_id" {}

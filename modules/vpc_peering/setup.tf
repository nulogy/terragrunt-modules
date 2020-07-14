provider "aws" {
  profile = "nulogy-anchor"
  alias   = "requester"
  version = "~> 2.0"
  assume_role {
    role_arn = "arn:aws:iam::${var.requester_account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  profile = "nulogy-anchor"
  alias   = "acceptor"
  version = "~> 2.0"
  assume_role {
    role_arn = "arn:aws:iam::${var.acceptor_account_id}:role/OrganizationAccountAccessRole"
  }
}
provider "aws" {
  alias   = "requester"
  version = "~> 2.0"
}

provider "aws" {
  alias   = "acceptor"
  version = "~> 2.0"
}
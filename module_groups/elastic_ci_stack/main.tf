resource "aws_key_pair" "key_pair" {
  key_name = "${var.buildkite_env_name}-ci-instances"
  public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyg78R8xlzBcKFHDoUty/o+DIzqvsZ/ZC+aD4RIs8lBM6JlIEb/YUIIYgrshDEUYxg8dkxRTMD/wbWmmiwKR+1H8ahVhd2ri0YW+ru1qrHSFYfKvmbw0k9VyKU1r72UCX+29BVgngsNnlsxwF/dRIKejdlgrFfN1WBVVkxvZx3F0KzI+osT22HClgojL8Nonrrne+jcJrsFAAB0kpKtVLLXndZMhjQBbkLauNDAos+W+s8wi+qdMc5Ng8yWzeE+JWHpKKmoOLH1h9azs5QiVmZyMYinCdqxZMMR5XJKOPFhgYUbCMzTh6xld3/8gZbLezlIF1tia9uR0n+pIQjMd25wIDAQAB"
}

module "ecr" {
  source = "../../modules/ecr"

  name = "${var.buildkite_env_name}-builds"
}

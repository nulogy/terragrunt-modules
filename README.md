# Nulogy Deployer

Note: Make sure you're using the right credentials profile by setting this variable:

```
export AWS_PROFILE=profilename
```

## Creating a new personal environment

### Creating a personal notification system

1. Open [AWS SNS](https://us-east-2.console.aws.amazon.com/sns/v2/home#/topics) to create a personal topic
1. Make sure you are on the same region your environment will be hosted.
1. Create a new topic with name 'go-\`whoami\`' (for example `go-arturopie`)
1. Open the new topic
1. Create a subscription using `email` protocol and your nulogy email address
1. Open your email inbox and confirm subscription.

### Setting Up a KMS Master Key

Each environment will need its own KMS key. To create one run:

```bash

region=<your region>
environment="go-$(whoami)"

kms_key_id=$(aws kms create-key --origin AWS_KMS --region $region --query "KeyMetadata.KeyId" --output text)

aws kms create-alias --alias-name "alias/$environment" \
  --target-key-id $kms_key_id \
  --region $region
```

**NOTE:** Setting the Administrators for a KMS key does not prevent other admin users on the AWS account from being able to decrypt using that key.

Set your key ID for your environment:

1. Open your `vars.<your environment>.tfvars` file.
1. Add a `kms_key_id` with `$kms_key_id` as the value.

### Setting up a new parameter store for GO

Our infrastructure stack uses [AWS Parameter Store](http://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-paramstore.html) to securely store our account credentials (ie, database password, credentials for 3rd party services like Airbrake). For security reasons this step needs to be done manually.

```
aws ssm put-parameter --name "/${environment}/RDS/db-password" --value "th1sIsS3cure" --type "SecureString" --key-id "${kms_key_id}" --region $region
aws ssm put-parameter --name "/${environment}/GO/admin-password" --value "th1sIsS3cure" --type "SecureString" --key-id "${kms_key_id}" --region $region
```

### Upload certificate for load balancers

Get the certificate for `nulogy-dev.net` from infrastructure 1Password:

```
aws acm import-certificate --certificate file://cert.pem --certificate-chain file://chain.pem --private-key file://key.pem --region $region
```

### Setting up infrastructure

Create a Terraform configuration file based on an existing one:

```
sed -e "s:go-arturopie:go-`whoami`:g" deployer/apps/go/vars.arturopie.tfvars > deployer/apps/go/vars.`whoami`.tfvars
```

Commit and push the new `.tfvars` file to our git repo.

Currently we don't have a way to create a set of parameter store variables for every new environment, so save time by using an existing one:

```
param_store_namespace = "go-arturopie"
```

And inside the nulogy-deployer container, run prepare to create the new environment:

```
./apps/go/prepare.sh mypersonal
```

## Deploy a new service

And inside the nulogy-deployer container, run deploy to deploy a new service:

```
./apps/go/deploy.sh mypersonal
```

## Check the service URL

Visit: https://`<environment>`.nulogy-dev.net

## Testing local terraform changes

Run nulogy-deployer container:

```
./develop_deployer.sh
```

## Release a new Image version

1. Bump the version in `versions.env`
1. Run `build_nulogy_deployer.sh`
1. Commit the version `git commit -m "new version 0.2" .`
1. Tag `git tag "0.2"`
1. Push everything: `git push origin master && git push --tags`
1. Push the new Image: `push_nulogy_deployer.sh`

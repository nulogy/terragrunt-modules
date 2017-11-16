# Nulogy Deployer

Note: Make sure you're using the right credentials profile by setting this variable:

```
export AWS_PROFILE=profilename
```

## Creating a new personal environment in us-east-2 region

### Create a Terraform configuration file based on an existing one:

```
./develop_deployer.sh
environment=<your-environment-name>
mkdir apps/go/us-east-2/"$environment"/
sed -e "s:go-arturopie:go-"$environment":g" apps/go/us-east-2/arturopie/terraform.tfvars > apps/go/us-east-2/"$environment"/terraform.tfvars
```

Commit and push the new `.tfvars` file.

### Create initial infrastructure resources

```
cd apps/go/us-east-2/"$environment"/
terragrunt apply -target module.setup
```


### Creating a personal notification system

1. Open the url returned by this command: `echo https://us-east-2.console.aws.amazon.com/sns/v2/home?region=us-east-2#/topics/"$(terragrunt output topic_arn 2> /dev/null)"`
1. Create a subscription using `email` protocol and your nulogy email address
1. Open your email inbox and confirm subscription.

### Storing your credentials in parameter store for GO

Our infrastructure stack uses [AWS Parameter Store](http://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-paramstore.html) to securely store our account credentials (ie, database password, credentials for 3rd party services like Airbrake). For security reasons this step needs to be done manually. **NOTE:** Setting the Administrators for the environment KMS key does not prevent other admin users on the AWS account from being able to decrypt using that key.


```
../../generate_credentials.sh  # run this from your environment's directory
```

### If this is the first environment on the region: upload certificate for load balancers

Get the certificate for `nulogy-dev.net` from infrastructure 1Password:

```
aws acm import-certificate --certificate file://cert.pem --certificate-chain file://chain.pem --private-key file://key.pem --region $region
```

### Deploying infrastructure

```
terragrunt apply
```

## Deploy assets

```
../../deploy.sh us-east-2/"$environment"
```

## Check the service URL

Visit: https://"$environment".nulogy-dev.net

Find the password by going to AWS Param Store (in EC2)
Find the parameter with the name /go-"$environment"/GO/admin-password
Get the password by copying the value of that parameter
As the user, use `admin@nulogy.com`


## To destroy an environment, run

```
apps/go/destroy.sh <region>/<environment>
```

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

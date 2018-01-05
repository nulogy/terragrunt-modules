# Nulogy Deployer

## Login to nulgoy-deployer ECR

```
$(aws ecr get-login --no-include-email --region us-east-2 --profile <PROFILE NAME>)
```

Copy and run the above command output to log in.

## Testing local terraform changes

Run nulogy-deployer container:

```
./develop_deployer.sh <docker-image-used-for-testing-deployments>
```

## Release a new Image version

1. Bump the version in `versions.env`
1. Run `./build_and_release.sh`

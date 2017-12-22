# Nulogy Deployer

## Testing local terraform changes

Run nulogy-deployer container:

```
./develop_deployer.sh <docker-image-used-for-testing-deployments>
```

## Release a new Image version

1. Bump the version in `versions.env`
1. Run `./build_and_release.sh`

# Nulogy Deployer

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

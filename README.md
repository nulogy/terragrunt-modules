# Nulogy Deployer

## Contributing

We treat this project as an internal "open source" project. Everyone at Nulogy is welcome to submit Merge Requests.

### Testing local terraform changes

1. Create a symbolic link from one of your apps to deployer/app_source. For example:

    ln -s ~/src/go/infrastructure/terraform deployer/apps_source/go

1. Run nulogy-deployer container:

```
./develop_deployer.sh <docker-image-used-for-testing-deployments>
```

**NOTE: Never run `tg.sh apply` on any production environment since it will change the terraform state. If you want to see changes your new code will make, run `tg.sh plan`**

### Merging changes to master

The Directly Responsible Individual (DRI) for this project is Cameron Ross.

When you are happy with your changes:

1. Add description of changes to the top of the [CHANGELOG](./CHANGELOG.md) file.
1. Create a Merge Request.
1. Notify #nulogy-deployer Slack channel to get the DRI review and merge your changes.
1. If there are changes affecting files in `deployer/apps/<product>`. A member of the team owning `<product>` should also review the MR.

NOTE: Only the nulogy-deployer core team is allowed to merge changes to master

### Release a new Image version

Only the DRI is allowed to release new versions.

1. Bump the version in `versions.env`. We use [Semantic versions](https://semver.org/).
1. Add version header to [CHANGELOG](./CHANGELOG.md) file.
1. Run `./build_and_release.sh`.

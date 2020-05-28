# Terragrunt Modules

## Contributing

We treat this project as an internal "open source" project. Everyone at Nulogy is welcome to submit Merge Requests.

### Merging changes to master

When you are happy with your changes:

1. Add description of changes to the top of the [CHANGELOG](./CHANGELOG.md) file, under the `## [Unreleased]` section.
1. Create a Pull Request.
1. Notify #nulogy-deployer Slack channel for a review.

### Release a new version

1. Bump the version in `versions.env`. We use [Semantic versions](https://semver.org/).
1. Open the [CHANGELOG](./CHANGELOG.md) file.
1. Change `## [Unreleased]` to version number and date (e.g. `## [0.11.0] - 2018-04-20`)
1. Remove the headers with no content (e.g. Added, Changed, etc)
1. Copy the following 'Unreleased' block to the top of the list.

    ```
    ## [Unreleased]

    ### Added
    ### Changed
    ### Deprecated
    ### Removed
    ### Fixed
    ### Security
    ```

1. Run `./build_and_release.sh`

### RubyMine

We recommend installing the `HashiCorp Terraform / HCL language Support` plugin

### Nulogy-Deployer Core Team

* Cameron Ross - DRI
* Arturo Pie

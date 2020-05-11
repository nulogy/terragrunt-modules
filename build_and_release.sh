#!/usr/bin/env bash

(
  set -eo pipefail
  IFS=$'\n\t'

  readonly LOG_FILE="/tmp/$(basename "$0").log"
  info()    { echo "[INFO]    $*" | tee -a "$LOG_FILE" >&2 ; }

  source ./versions.env

  info "Commiting version bump"
  git commit -m "bump to version $TERRAGRUNT_MODULES_VERSION" CHANGELOG.md versions.env
  git tag "$TERRAGRUNT_MODULES_VERSION"

  info "Pushing repo"
  git push && git push --tags
)

#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

# these should be found in PATH
backup_luks.sh "$@"

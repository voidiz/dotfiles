#!/usr/bin/env bash

set -euo pipefail

# Override existing stowed packages
# and don't create directory symlinks
stow "$@" --override=.+ --no-folding

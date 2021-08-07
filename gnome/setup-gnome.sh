#!/usr/bin/env bash

set -eu

# do this after install
# dconf load /org/gnome/ < org-gnome-dconf

tmpdir=$(mktemp -d)
git clone git@github.com:pop-os/shell $tmpdir
patch $tmpdir/schemas/org.gnome.shell.extensions.pop-shell.gschema.xml pop-shell-bindings.patch
cd $tmpdir
make local-install

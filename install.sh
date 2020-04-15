#!/usr/bin/env bash
set -euxo pipefail

[[ -z "$1" ]] && echo "usage: install.sh <file.nix>" && exit 1

# This is the file that ~/.config/nixpkgs/home.nix will symlink to
NIXFILE="$PWD/$1"

NIXDIR=${XDG_HOME_CONFIG:-~/.config}/nixpkgs
mkdir -p $NIXDIR

# symlink ~/.config/nixpkgs/[home|config|overlays].nix into files in this repo
[[ -e "$NIXDIR/home.nix" ]] || ln -fs "$NIXFILE" "$NIXDIR/home.nix"
# TODO: remove these
#[[ -e "$NIXDIR/config.nix" ]] || ln -fs "$PWD/nixpkgs/config.nix" "$NIXDIR/config.nix"
#[[ -e "$NIXDIR/overlays.nix" ]] || ln -fs "$PWD/nixpkgs/overlays.nix" "$NIXDIR/overlays.nix"

# symlinking must occur before initial generation. now we can install, and
# pin our own nixpkgs through use of ./nix/sources.nix
nix-shell ./default.nix -A install

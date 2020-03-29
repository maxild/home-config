#!/usr/bin/env bash
set -euxo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

nixpkgsConfig=${XDG_HOME_CONFIG:-~/.config}/nixpkgs

mkdir -p $nixpkgsConfig
ln -fs "$DIR/home.nix" "$nixpkgsConfig/home.nix"

NIX_PATH=nixpkgs=https://releases.nixos.org/nixos/unstable/nixos-20.03pre206632.b0bbacb5213/nixexprs.tar.xz
HM_PATH=${HM_PATH:-https://github.com/rycee/home-manager/archive/master.tar.gz}

# install home manager and create the first generation
nix-shell $HM_PATH -A install
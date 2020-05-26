{ pkgs, ... }:

let
  # Credits: Burke Libbey (https://github.com/Shopify/comma)
  # usage example:
  #   $ , yarn --help
  # This finds a derivation providing a bin/yarn, and runs it with `nix run`.
  # If there are multiple candidates, the user chooses one using `fzy`.
  #
  # `nix run` is a “new interface”, part of nix 2.0.
  # `nix run pkg1 pkg2` supersedes `nix-shell -p pkg1 pkg2`, but `nix-shell -A pkg`
  # has no equivalent in the new `nix run` CLI. The magic of `nix-shell -A pkg` is
  # that it goes trough all the dependencies of pkg and starts a shell with these
  # packages in the environment.
  comma = pkgs.writeShellScriptBin "," ''
    set -euo pipefail

    if [[ $# -lt 1 ]]; then
      echo "usage: , <program> [arguments]" 1>&2
      exit 1
    fi

    # We need "$@"" below, so shift the mandatory command/program
    command=$1; shift

    # nix-locate is able to search for an absolute file path /bin/''${command} within
    # nixpkgs and report back the attr name of the derivation
    attr="$(${pkgs.nix-index}/bin/nix-locate --top-level --minimal --at-root --whole-name "/bin/''${command}")"
    if [[ "$(echo "''${attr}" | wc -l)" -ne 1 ]]; then
      attr="$(echo "''${attr}" | ${pkgs.fzy}/bin/fzy)"
    fi

    if [[ -z $attr ]]; then
      echo "no match" 1>&2
      exit 1
    fi

    # Example:
    # You can (magically) run a command in nix (without using a subshell, i.e. nix-shell) by running
    # $ nix run nixpkgs.ripgrep -c rg ""
    ${pkgs.nix}/bin/nix run "nixpkgs.''${attr}" -c "''${command}" "$@"
  '';

in {
  home.packages = with pkgs; [
    comma
    # so that we can build the database
    nix-index
  ];
}

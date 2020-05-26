{ pkgs, ... }:

let
  # Credits: Burke Libbey (https://github.com/Shopify/comma)
  # usage example:
  #   $ , yarn --help
  # This finds a derivation providing a bin/yarn, and runs it with `nix run`.
  # If there are multiple candidates, the user chooses one using `fzy`.
  comma = pkgs.writeScriptBin "," ''
    #!${pkgs.stdenv.shell}
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

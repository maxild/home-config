let
  # TODO: Add home-manager to sources
  sources = import ./nix/sources.nix;

  # this is the pinned package set
  pkgs = import sources.nixos-20-03 ({
    config = import ./nixpkgs/config.nix;
    overlays = import ./nixpkgs/overlays.nix;
  });

in pkgs.mkShell rec {

  name = "nixfiles-shell";

  buildInputs = with pkgs; [
    jq
    #nix
    #niv
  ];

  shellHook = ''
    # export HOME_MANAGER_CONFIG=$PWD/home.nix
    # TODO: Also pin home-manager in NIX_PATH
    export NIX_PATH="nixpkgs=${sources.nixpkgs}"
    # function switch () {
    #   home-manager switch
    # }
  '';

}

let
  # TODO: Add home-manager to sources
  sources = import ./nix/sources.nix;

  # this is the pinned package set
  pkgs = import sources.nixpkgs ({
    config = {};
    # TODO: Overlays should be added here
  });

  #spec = builtins.fromJSON (builtins.readFile ./nix/nixos-19-09.json);
  # pkgs = builtins.fetchFromGitHub {
  #   owner = "NixOS";
  #   repo  = "nixpkgs-channels";
  #   inherit (spec) rev sha256;
  # };

in pkgs.mkShell rec {

  name = "nixfiles-shell";

  buildInputs = with pkgs; [
    jq
    #nix
    #niv
  ];

  shellHook = ''
    export HOME_MANAGER_CONFIG=$PWD/home.nix
    # TODO: Also pin home-manager in NIX_PATH
    export NIX_PATH="nixpkgs=${sources.nixpkgs}"
    function switch () {
      home-manager switch
    }
  '';

}
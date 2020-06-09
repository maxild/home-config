{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nix-prefetch-git
    nix-prefetch-github
    niv
    #nodePackages.node2nix
    #go2nix
    #nixops
    #cachix
  ];
}

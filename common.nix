{ config, pkgs, lib, ... }:

{
  imports = [
    ./apps.nix
    ./dev.nix
    ./environment.nix
    ./modules/home-manager.nix
  ];

  # TODO: This should be the same in home.nix and darwin-configuration.nix
  nixpkgs.config = import ./nixpkgs/config.nix;
  nixpkgs.overlays = import ./nixpkgs/overlays.nix;
  # Create symlink into the nix store where config.nix and overlays.nix are copied
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs/config.nix;
  xdg.configFile."nixpkgs/overlays.nix".source = ./nixpkgs/overlays.nix;
}

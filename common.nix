{ config, pkgs, lib, ... }:

let
  allPlatformImports = [
    ./apps.nix
    # TODO: refactor dev
    ./dev.nix
    ./environment.nix
    ./modules/home-manager.nix
    #./home/shells.nix
    #./home/tmux.nix
  ];
  linuxImports = [
    #./home/terminal.nix
    #./home/i3.nix
    #./home/irc.nix
  ];
in
{
  imports = if builtins.currentSystem == "x86_64-linux"
            then (allPlatformImports ++ linuxImports)
            else allPlatformImports;

  # TODO: This should be the same in home.nix and darwin-configuration.nix
  nixpkgs.config = import ./nixpkgs/config.nix;
  nixpkgs.overlays = import ./nixpkgs/overlays.nix;
  # Create symlink into the nix store where config.nix and overlays.nix are copied
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs/config.nix;
  xdg.configFile."nixpkgs/overlays.nix".source = ./nixpkgs/overlays.nix;
}

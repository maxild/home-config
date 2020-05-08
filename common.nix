{ config, pkgs, lib, ... }:

let
  allPlatformImports = [
    ./home/apps.nix
    ./home/shells.nix

    # See https://discourse.nixos.org/t/libgl-undefined-symbol-glxgl-core-functions/512
    #./home/alacritty.nix
    
    #./tmux.nix
    #./vim.nix
    ./home/git.nix
    ./home/xdg.nix
    ./home/nix.nix
    ./home/environment.nix
    ./modules/home-manager.nix
  ];
  linuxImports = [
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
  nixpkgs.overlays = [
    ( import ./overlays/bcompare.nix )
  ];
  # Create symlink into the nix store where config.nix and overlays.nix are copied
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs/config.nix;
  #xdg.configFile."nixpkgs/overlays.nix".source = ./nixpkgs/overlays.nix;
}

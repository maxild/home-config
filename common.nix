{ config, pkgs, lib, ... }:

# General notes
# * home-manager creates a single package combining all your home-manager packages, then uses nix-env to install it.
# * About pinning nixpkgs see https://github.com/rycee/home-manager/issues/266#issuecomment-390390166

let
  allPlatformImports = [
    ./home/apps.nix
    ./home/shells.nix
    ./home/comma.nix

    # See https://discourse.nixos.org/t/libgl-undefined-symbol-glxgl-core-functions/512
    #./home/alacritty.nix

    ./home/tmux.nix
    ./home/git.nix
    ./home/xdg.nix
    ./home/nix.nix
    ./home/dev.nix
    ./home/environment.nix
    ./modules/home-manager.nix
    ./home/vim.nix
  ];
  linuxImports = [
  ];
in
{
  imports = if builtins.currentSystem == "x86_64-linux"
            then (allPlatformImports ++ linuxImports)
            else allPlatformImports;

  # TODO: This should be the same in home.nix and darwin-configuration.nix
  nixpkgs.config = import ./nixpkgs/config.nix;
  nixpkgs.overlays = import ./nixpkgs/overlays;

  # NOTE: It is possible to place the config and overlays in
  # ~/.config/nixpkgs folder and this way they will be applied
  # both inside and outside HM (.i.e. using nix-env)

  # Create symlink into the nix store where config.nix and overlays.nix are copied
  #xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs/config.nix;
  # TODO: It does not work to add ./nixpkgs/overlays/default.nix this way without
  # also adding the files this file will import
  #xdg.configFile."nixpkgs/overlays.nix".source = ./nixpkgs/overlays/default.nix;
}

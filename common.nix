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
    #./home/environment.nix
    ./modules/home-manager.nix
  ];
  linuxImports = [
    ./home/vim.nix
  ];
in
{
  imports = if builtins.currentSystem == "x86_64-linux"
            then (allPlatformImports ++ linuxImports)
            else allPlatformImports;

  # TODO: This should be the same in home.nix and darwin-configuration.nix
  nixpkgs.config = import ./nixpkgs/config.nix;
  nixpkgs.overlays = [
    #( import ./overlays/neovim.nix )
    ( import ./overlays/bcompare.nix )
    ( import ./overlays/dotnet.nix )
  ];
  # Create symlink into the nix store where config.nix and overlays.nix are copied
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs/config.nix;
  #xdg.configFile."nixpkgs/overlays.nix".source = ./nixpkgs/overlays.nix;
}

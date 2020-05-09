{ pkgs, lib,... }:

{
  imports = [
    ../modules/settings.nix
    ../common.nix
  ];

  config.settings = with lib; mapAttrs (_: v: mkDefault v) {
    host.isHeadless = false; # nix-darwin will install gui apps like alacritty, spotify etc
  };
}

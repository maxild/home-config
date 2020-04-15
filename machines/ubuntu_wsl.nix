{ pkgs, lib,... }:

{
  imports = [
    ../modules/settings.nix
    ../common.nix
  ];

  config.settings = with lib; mapAttrs (_: v: mkDefault v) {
    isWsl = true;
  };
}

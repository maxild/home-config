{ config, pkgs, ... }:

{
  #
  # installs into /.nix-profile/bin/
  #
  home.packages = with pkgs; [
    # Utilities
    wget
    jq
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}

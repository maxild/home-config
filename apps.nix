{ config, pkgs, ... }:

{
  #
  # installs into /.nix-profile/bin/
  #
  home.packages = with pkgs; [
    # Utilities
    coreutils
    findutils
    wget
    curl
    tree

    # jetbrains.rider

    # (with dotnetCorePackages; combinePackages [
    #   sdk_2_1
    #   sdk_3_0
    #   sdk_3_1
    # ])
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        #ms-python.python
      ];
  };

  #programs.htop.enable = true;

  programs.jq.enable = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}

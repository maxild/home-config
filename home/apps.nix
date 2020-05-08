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

    # TODO: cp bcompare.desktop /usr/share/applications (GNOME)
    # BUT bcompare.desktop is not part of build
    # Installed desktop applications have dsktop files here: ~/.nix-profile/share/applications
    bcompare

    spotify

    # jetbrains.rider

    # (with dotnetCorePackages; combinePackages [
    #   sdk_2_1
    #   sdk_3_0
    #   sdk_3_1
    # ])
  ];

  # https://vscode-update.azurewebsites.net/1.44.2/linux-x64/stable
  programs.vscode = {
    enable = true;
    #package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      #vscodevim.vim
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

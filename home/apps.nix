{ config, pkgs, ... }:

let
  # only install gui apps if host has desktop environment (e.g. GNOME) and is not WSL
  guiHost = !config.settings.host.isHeadless && !config.settings.host.isWsl;

  cliApps = with pkgs; [
    # Utilities
    coreutils
    findutils
    wget
    curl
    tree

    # (with dotnetCorePackages; combinePackages [
    #   sdk_2_1
    #   sdk_3_0
    #   sdk_3_1
    # ])
  ];
  guiApps = with pkgs; [
    # TODO: cp bcompare.desktop /usr/share/applications (GNOME)
    # BUT bcompare.desktop is not part of build
    # Installed desktop applications have dsktop files here: ~/.nix-profile/share/applications
    bcompare
    spotify
    google-chrome
    jetbrains.rider
  ];
in
{
  #
  # installs into /.nix-profile/bin/
  #
  home.packages = if guiHost
                  then (cliApps ++ guiApps)
                  else cliApps;

  # https://vscode-update.azurewebsites.net/1.44.2/linux-x64/stable
  programs.vscode = {
    enable = guiHost;
    #package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      #vscodevim.vim
      #ms-python.python
    ];
  };

  programs.htop.enable = true;

  programs.jq.enable = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}

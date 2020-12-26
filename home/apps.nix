{ config, pkgs, ... }:

let
  # only install gui apps if host has desktop environment (e.g. GNOME) and is not WSL
  guiHost = !config.settings.host.isHeadless && !config.settings.host.isWsl;

  cliApps = with pkgs; [
    git
    gitAndTools.gh
    # Utilities
    coreutils
    findutils
    wget
    curl
    htop
    jq
    direnv
    # A modern replacement for ls -- https://the.exa.website/
    exa
    # A cat(1) clone with syntax highlighting and Git integration -- https://github.com/sharkdp/bat
    bat
    # A simple, fast and user-friendly alternative to 'find' -- https://github.com/sharkdp/fd
    fd
    # a modern grep
    ripgrep
    # linter for shell scripts
    shellcheck
    # community/example driven manpages
    tldr
    # fuzzy finder
    fzf
    # A better 'tree' command
    # See https://dystroy.org/broot/ and https://github.com/Canop/broot
    broot
    tree
    # A `cd' command that learns
    autojump
    # Remote repository management made easy
    ghq
    # TODO: ld, ranger, nnn, fasd
  ];
  guiApps = with pkgs; [
    # TODO: cp bcompare.desktop /usr/share/applications (GNOME)
    # BUT bcompare.desktop is not part of build
    # Installed desktop applications have dsktop files here: ~/.nix-profile/share/applications
    bcompare
    spotify
    #google-chrome
    #jetbrains.rider
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
  #programs.vscode = {
  #  enable = guiHost;
  #  #package = pkgs.vscodium;
  #  extensions = with pkgs.vscode-extensions; [
  #    #vscodevim.vim
  #    #ms-python.python
  #  ];
  #};

  programs.htop.enable = true;

  programs.jq.enable = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.broot = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # A command-line fuzzy finder
  # See https://github.com/junegunn/fzf
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    # follow symbolic links and include hidden files (but exclude .git folders)
    #defaultCommand = "${pkgs.fd}/bin/fd --type file --follow --hidden --exclude .git";
    defaultCommand = ''${pkgs.ripgrep}/bin/rg --files --no-ignore --hidden --follow --glob "!.git/*"'';
  };
}

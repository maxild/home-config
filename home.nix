{ config, pkgs, ... }:

{
  imports = [
    ./apps.nix
    ./dev.nix
    ./environment.nix
  ];

  nixpkgs.config = import ./nixpkgs/config.nix;
  nixpkgs.overlays = import ./nixpkgs/overlays.nix;
  # Create symlink into the nix store where config.nix and overlays.nix are copied
  xdg.configFile."nixpkgs".source = ./nixpkgs;

  programs.home-manager.enable = true;
  # TODO: Use git submodule checkout in vendor subdir
  # programs.home-manager.path = "${builtins.toPath ../vendor/home-manager}";
  programs.home-manager.path = "https://github.com/rycee/home-manager/archive/master.tar.gz";

  # TODO: This should be the same in home.nix and darwin-configuration.nix
  #nixpkgs.config = import ./nixpkgs.nix;
  #nixpkgs.overlays = [(import ../pkgs/default.nix)];
  #xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs.nix;

  # XDG:
  # * There is a single base directory relative to which user-specific data files
  #   should be written. This directory is defined by the environment variable
  #      $XDG_DATA_HOME = ~/.local/share
  # * There is a single base directory relative to which user-specific configuration
  #   files should be written. This directory is defined by the environment variable
  #      $XDG_CONFIG_HOME = ~/.config (default value)
  # * There is a set of preference ordered base directories relative to which data
  #   files should be searched. This set of directories is defined by the environment
  #   variable
  #      $XDG_DATA_DIRS = /usr/local/share/:/usr/share/ or EMPTY
  # * There is a set of preference ordered base directories relative to which
  #   configuration files should be searched. This set of directories is defined
  #   by the environment variable
  #      $XDG_CONFIG_DIRS.
  # * There is a single base directory relative to which user-specific non-essential
  #   (cached) data should be written. This directory is defined by the environment
  #   variable
  #      $XDG_CACHE_HOME.
  # * There is a single base directory relative to which user-specific runtime files
  #   and other file objects should be placed. This directory is defined by the
  #   environment variable
  #      $XDG_RUNTIME_DIR.

  # Attribute set of files to link into the user's XDG_CONFIG_HOME
  # This will create a symlinked .inputrc file in the ~/.config folder

  #
  # Shell configuration
  #

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    #defaultKeymap = "emacs";
    dotDir = ".config/zsh";
    history = {
      expireDuplicatesFirst = true;
      path = ".config/zsh/.zsh_history";
    };
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "osx" "sudo" "web-search"];
      theme = "robbyrussell";
    };
    shellAliases = {
      "ll" = "ls -al";
      "ns" = "nix-shell --command zsh";
    };
    # initExtra = let
    #   cdpath = "$HOME/src" +
    #     optionalString (config.settings.profile != "malloc47")
    #       " $HOME/src/${config.settings.profile}";
    # in
    # ''
    #   hg() { history | grep $1 }
    #   pg() { ps aux | grep $1 }

    #   function chpwd() {
    #     emulate -L zsh
    #     ls
    #   }

    #   cdpath=(${cdpath})
    # '';
    sessionVariables = {
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10";
    };
  };

  # TODO: Migrate ~/.bash_profile from dotfiles over here
  # programs.bash = {
  #   enable = true;
  #   historyFile = "\$HOME/.config/bash/.bash_history";
  #   shellAliases = {
  #     ".." = "cd ..";
  #     "..." = "cd ../../";
  #     "...." = "cd ../../../";
  #     "....." = "cd ../../../../";
  #     "......" = "cd ../../../../../";
  #     "ll" = "ls -al";
  #     "ns" = "nix-shell --command zsh";
  #   };
  #   initExtra = ''
  #     hg() { history | grep "$1"; }
  #     pg() { ps aux | grep "$1"; }
  #     cd() { if [[ -n "$1" ]]; then builtin cd "$1" && ls; else builtin cd && ls; fi }
  #   '';
  #   sessionVariables = {
  #     EDITOR = "vim";
  #   };
  #   shellOptions = [
  #     "autocd" "cdspell" "dirspell" "globstar" # bash >= 4
  #     "cmdhist" "nocaseglob" "histappend" "extglob"];
  # };

  #
  # Dotfiles
  #

  # custom pre-defined dotfiles
  xdg.configFile = {
    ".inputrc".source = ./.inputrc;
    # Equivalent to this
    #".inputrc".text = builtins.readFile ./.inputrc;
  };

  # TODO: Investigate XDG
  # TODO: xdg.configFile vs home.file???
  #home.file.".inputrc".source = ./.inputrc;
  #xdg.configFile.".user-dirs.dirs".source = ./.user-dirs.dirs;

  # TODO: Emacs
  # home.file.".emacs.d" = {
  #   source = ./.emacs.d;
  #   recursive = true;
  # };

  #
  # Services
  #

  # NOTE: Does not work in home-manager on Darwin
  #services.lorri.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "19.09";
}

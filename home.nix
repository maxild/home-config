{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  programs.home-manager.path =
    "https://github.com/rycee/home-manager/archive/master.tar.gz";

  nixpkgs.config = import ./nixpkgs-config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;
  
  #
  # installs into /.nix-profile/bin/
  #
  home.packages = [
    pkgs.curl
    pkgs.vim
  ];

  #
  # Git config
  #

  # TODO: Move all --global config here. Old dotfiles uses
  # ~/.gitconfig. Home-manager uses ~/.config/git/config
  programs.git = {
    enable = true;
    userName = "maxild2";
    userEmail = "mmaxild2@gmail.com";
  };

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

  # TODO

  #
  # Dotfiles
  #

  # custom pre-defined dotfiles
  xdg.configFile = {
    ".inputrc".source = ./.inputrc;
    # Equivalent to this
    #".inputrc".text = builtins.readFile ./.inputrc;
  };

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

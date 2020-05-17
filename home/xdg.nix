{ ... }:

{
  xdg.enable = true;

  # ~/.config (XDG) dotfiles
  xdg.configFile = {
    "nvim/essential.vim".source = ../dotfiles/essential.vim;
    ".inputrc".source = ../dotfiles/.inputrc;
    "alacritty/alacritty.yml".source = ../dotfiles/alacritty.yml;
    "tmux/yank.sh".source = ../scripts/yank.sh;
  };

  # ~/ (HOME) dotfiles
  home.file.".editorconfig".source = ../dotfiles/root.editorconfig;
}

# TODO: remove this
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

  # TODO: Investigate XDG
  # TODO: xdg.configFile vs home.file???
  #home.file.".inputrc".source = ./.inputrc;
  #xdg.configFile.".user-dirs.dirs".source = ./.user-dirs.dirs;

  # TODO: Emacs
  # home.file.".emacs.d" = {
  #   source = ./.emacs.d;
  #   recursive = true;
  # };


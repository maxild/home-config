{ config, lib, pkgs, ... }:

let
  commonShellConfig = {
    shellAliases = {
      l = "exa";
      ls = "exa";
      ll = "exa -all --long --header";
      g = "git";
      e = "eval $EDITOR";
      f = "fzf --preview 'bat --style=numbers --color=always {} | head -500'";
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";
      "......" = "cd ../../../../../";
    };
    initExtra = ''
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    hg() { history | grep "$1"; }
    pg() { ps aux | grep "$1"; }
    if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
      . ~/.nix-profile/etc/profile.d/nix.sh;
      export NIX_PATH=$HOME/.nix-defexpr/channels''${NIX_PATH:+:}$NIX_PATH
    fi # added by Nix installer
    '';
  };
in
{
  home.packages = with pkgs; [
    kitty
    # A modern replacement for ls -- https://the.exa.website/
    exa
    # A cat(1) clone with syntax highlighting and Git integration -- https://github.com/sharkdp/bat
    bat
    # A simple, fast and user-friendly alternative to 'find' -- https://github.com/sharkdp/fd
    fd
  ];

  # See https://sw.kovidgoyal.net/kitty/conf.html for documentation
  xdg.configFile."kitty/kitty.conf".source = ../dotfiles/kitty.conf;

  # TODO: Migrate ~/.bash_profile from dotfiles over here
  programs.bash = ({
    enable = true;
    historyControl = [ "erasedups" ];
    historyFile = "\$HOME/.config/bash/.bash_history";
    historyIgnore = [ "l" "ls" "cd" "exit" ];
    enableAutojump = true;
    sessionVariables = {
      EDITOR = "vim";
    };
    shellOptions = [
      "autocd" "cdspell" "dirspell" "globstar" # bash >= 4
      "cmdhist" "nocaseglob" "histappend" "extglob"];
  } // commonShellConfig);

  programs.zsh = ({
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
    sessionVariables = {
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10";
    };
  } // commonShellConfig);

  # A better 'tree' command
  # See https://dystroy.org/broot/ and https://github.com/Canop/broot
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
    defaultCommand = "${pkgs.fd}/bin/fd --type file --follow --hidden --exclude .git";
    #defaultCommand = "${pkgs.ripgrep}/bin/rg --files";
  };
}

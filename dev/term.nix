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
    # A modern replacement for ls -- https://the.exa.website/
    exa
    # A cat(1) clone with syntax highlighting and Git integration -- https://github.com/sharkdp/bat
    bat
    # A simple, fast and user-friendly alternative to 'find' -- https://github.com/sharkdp/fd
    fd
  ];

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
    defaultCommand = "${pkgs.fd}/bin/fd --type f";
    #defaultCommand = "${pkgs.ripgrep}/bin/rg --files";
  };
}

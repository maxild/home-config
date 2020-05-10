{ config, lib, pkgs, ... }:

let
  # Note: If the user starts a login shell (bash) that multiplexes his terminal to create several separate "screens" (using tmux), 
  # allowing him to interact with multiple concurrently running programs, then .bash_profile is called once (to setup the environment),
  # and .bashrc is called for every process (parent shell, and child subshells running in multiplexed shell)
  # 
  # Init of the environment for BASH and ZSH
  #    .bash_profile: 
  #       * export variables into the environment. 
  #       * At the very end of your ~/.bash_profile, you should have the command source ~/.bashrc. That's 
  #         because when .bash_profile exists, bash behaves a little curious in that it stops looking for 
  #         its standard shell initialization file ~/.bashrc.
  #       * Note that if there is no ~/.bash_profile file, bash will try to read from ~/.profile instead, if it exists.
  #    .bashrc
  #       * Setup all things (aliases, functions etc) that are not inhereoited by default.
  #
  #    .zsenv????
  #       * 
  #    .zshrc
  #       * 
  locale = "en_GB.UTF-8";
  commonShellConfig = {
    shellAliases = {
      l = "exa";
      ls = "exa";
      ll = "exa -all --long --header";
      g = "git";
      e = "eval $EDITOR";
      f = ''fzf --preview "bat --style=numbers --color=always {} | head -500"'';
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";
      "......" = "cd ../../../../../";
      p = "cd ~/projects";
      dl = "cd ~/Downloads";
      ds = "cd ~/Documents";
      pnet = "cd ~/Projects/dotnet";
    };
    # TODO: Move to install.sh
    # When you are using a distribution other than NixOS, then your desktop environment (GNOME) will
    # be looking for your applications in /usr/share/applications while those installed with Nix are
    # actually in ~/.nix-profile/share/applications.
    #
    # It is important to note that the path needs to be added to this variable before your desktop
    # manager is started. How this is accomplished will vary by distro and/or login manager.
    #
    # Idea for creating symlinks, if XDG_DATA_DIRS cannot be picked up by GNOME
    # find ~/nix-profile/share/applications -type l -exec ln -s $HOME/{} $HOME/.local/share/applications
    # NOTE: Place desktop file in the /usr/share/applications directory so that it is accessible by everyone, or
    # in ~/.local/share/applications if you only wish to make it accessible to a single user.
    #
    # Add ~/.nix-profile/share to XDG_DATA_DIRS in order for GNOME to pickup desktop files
    # export XDG_DATA_DIRS="$HOME/.nix-profile/share:${XDG_DATA_DIRS}"
    #
    # TODO: Symlink ~/.nix-profile/share/applications into ~/.local/share/applications
    # TODO: patch/overlay/add the postInstall phase such that desktop file have absolute path to Icon file:
    #             sed -re 's@Icon=bcompare(dev)?[0-9.]*-?@Icon=@' -i "$out/share/applications/"*.desktop
    #
    #  Update the path to the kitty icon in the kitty.desktop file
    #     sed -i "s/Icon\=kitty/Icon\=\/home\/$USER\/.local\/kitty.app\/share\/icons\/hicolor\/256x256\/apps\/kitty.png/g" \
    #          ~/.local/share/applications/kitty.desktop
    initExtra =
    ''
    #export XDG_DATA_DIRS="''${XDG_DATA_DIRS:+''${XDG_DATA_DIRS}:}$HOME/.nix-profile/share"
    export LANG=${locale}
    function hg() { history | grep "$1"; }
    function pg() { ps aux | grep "$1"; }

    # zsh has no help command to inspect bash builtins
    function help() { bash -c "help $@"; }

    # switch to using bash/zsh in current shell session (without affecting new terminal windows or anything)
    function to_bash() { exec bash --login; }
    function to_zsh() { exec zsh --login; }

    # set default shell to bash
    function use_bash() {
      if [[ ! $(echo $SHELL) == $(which bash) ]]; then
        chsh -s $(which bash) $(whoami)
      fi
    }

    # set default shell to zsh
    function use_zsh() {
      if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh) $(whoami)
      fi
    }

    if [ -e "$HOME/bin" ]; then
      export PATH="$PATH:$HOME/bin"
    fi
    if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
      source "$HOME/.nix-profile/etc/profile.d/nix.sh"
      export NIX_PATH=$HOME/.nix-defexpr/channels''${NIX_PATH:+:}$NIX_PATH
    fi
    '';
  };
in
{
  home.packages = with pkgs; [
    #kitty
    # A modern replacement for ls -- https://the.exa.website/
    exa
    # A cat(1) clone with syntax highlighting and Git integration -- https://github.com/sharkdp/bat
    bat
    # A simple, fast and user-friendly alternative to 'find' -- https://github.com/sharkdp/fd
    fd
  ];

  # See https://sw.kovidgoyal.net/kitty/conf.html for documentation
  #xdg.configFile."kitty/kitty.conf".source = ../dotfiles/kitty.conf;

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
    # TODO: Investigate XDG and why we have a BUG with relative path .config/zsh and .config/.zsh/.zsh_history
    #dotDir = ".config/zsh";
    # history = {
    #   expireDuplicatesFirst = true;
    #   path = ".config/zsh/.zsh_history";
    # };
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "osx" "sudo" "web-search"];
      theme = "robbyrussell";
    };
    sessionVariables = {
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10";
    };
  } // commonShellConfig);

  # terminal multiplexer
  programs.tmux = {
      enable = true;
      sensibleOnTop = true;
      secureSocket = false;
      #terminal = "xterm-256color";
      terminal = "screen-256color";
      clock24 = true;
      extraConfig = builtins.readFile ../dotfiles/tmux;
    };


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

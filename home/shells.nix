{ config, lib, pkgs, ... }:

let
  # TODO: Vi command line editing in your shell, enabled with set -o vi in bash and bindkey -v in zsh,
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
      # clean vim (no vimrc and/or plugins)
      cvim = "nvim --clean -N";
      # minimal vim
      mvim = "nvim -u ~/.config/nvim/essential.vim";
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
      dotf = "cd ~/projects/config/home-config";
      ds = "cd ~/Documents";
      pnet = "cd ~/projects/dotnet";
      lofus = "cd ~/projects/dotnet/lofus";
      ffv = "cd ~/projects/dotnet/ffv-rtl";
      ffva = "cd ~/projects/dotnet/ffv-rtl-f3f5";
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
    export LOCALE_ARCHIVE="''$HOME/.nix-profile/lib/locale/locale-archive"
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

    # Nix-index provides a "command-not-found" script that can print for you the attribute path
    # of unfound commands in your shell.
    source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
  };
in
{
  # Use nix-index provided script
  programs.command-not-found.enable = false;

  # For a fast work-around on non-nixos, you can `nix-env -i glibc-locales` (for all locales
  # or a re-configured version of it, the attribute glibcLocales) and then point $LOCALE_ARCHIVE
  # to the corresponding lib/locale/locale-archive location (e.g. the one linked in a profile
  # after installation)


  # Better to use the systems man package on non-NixOS linux
  # https://github.com/rycee/home-manager/issues/432#issuecomment-434498787
  programs.man.enable = false;
  home.extraOutputsToInstall = [ "man" ];

  home.packages = with pkgs; [

    # See https://github.com/NixOS/nixpkgs/issues/38991
    #     https://gist.github.com/peti/2c818d6cb49b0b0f2fd7c300f8386bc3O
    # This together with setting LOCALE_ARCHIVE above is a known workaround for LC_ and LANG problems on non-NixOS
    glibcLocales
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
      # NOTE: non-BASH-specific environment variables should be placed
      # in environment.nix
    };
    shellOptions = [
      "autocd" "cdspell" "dirspell" "globstar" # bash >= 4
      "cmdhist" "nocaseglob" "histappend" "extglob"];
  } // commonShellConfig);

  programs.zsh = ({
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
    # TODO: Investigate XDG and why we have a BUG with relative path .config/zsh and .config/.zsh/.zsh_history
    #dotDir = ".config/zsh";
    history = {
      path = ".config/zsh/.zsh_history";
      size = 50000;
      save = 50000;
    };
    # history = {
    #   expireDuplicatesFirst = true;
    #   path = ".config/zsh/.zsh_history";
    # };
    # oh-my-zsh = {
    #   enable = true;
    #   plugins = ["git"];
    #   theme = "af-magic";
    # };
    # TODO: initExtra should not be merged in via commonShellConfig
    # TODO: use builtins.readFile to get syntax highligting (pre-compint.sh and post-compinit.sh, for initExtra)
    initExtraBeforeCompInit = ''
      PROMPT='%B%F{032}%~%f%b %# '
      RPROMPT='%F{105}%*'

      # Fancy substitutions in prompts
      setopt prompt_subst

      # If a command is issued that can’t be executed as a normal command, and the
      # command is the name of a directory, perform the cd command to that directory.
      setopt AUTO_CD

      # Treat  the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename
      # generation, etc.  (An initial unquoted ‘~’ always produces named directory
      # expansion.)
      setopt EXTENDED_GLOB

      # If a pattern for filename generation has no matches, print an error, instead
      # of leaving it unchanged in the argument  list. This also applies to file
      # expansion of an initial ‘~’ or ‘=’.
      setopt NOMATCH

      # no Beep on error in ZLE.
      setopt NO_BEEP

      # Remove any right prompt from display when accepting a command line. This may
      # be useful with terminals with other cut/paste methods.
      setopt TRANSIENT_RPROMPT

      # If unset, the cursor is set to the end of the word if completion is started.
      # Otherwise it stays there and completion is done from both ends.
      setopt COMPLETE_IN_WORD

      setopt auto_pushd
      setopt append_history

      # Show a highlighted '%' when the final line of output lacks a trailing
      # newline. Without this, the prompt overdraws that final line.
      setopt PROMPT_SP

      # I don't use the !!/etc. commands, so this means I don't have to carefully
      # quote/escape '!' in (e.g.) git commit messages.
      unsetopt PROMPT_BANG

      unsetopt MULTIOS
    '';
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.6.3";
          sha256 = "1h8h2mz9wpjpymgl2p7pc146c1jgb3dggpvzwm9ln3in336wl95c";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "be3882aeb054d01f6667facc31522e82f00b5e94";
          sha256 = "0w8x5ilpwx90s2s2y56vbzq92ircmrf0l5x8hz4g1nx3qzawv6af";
        };
      }
    ];
    sessionVariables = {
      # NOTE: non-ZSH-specific environment variables should be placed
      # in environment.nix
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

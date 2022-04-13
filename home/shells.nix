{ config, lib, pkgs, ... }:

let
  sources = import ../nix/sources.nix;
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
  #       * Setup all things (aliases, functions etc) that are not inherited by default.
  #
  #    .zsenv????
  #       *
  #    .zshrc
  #       *
  commonShellAliases = {
    # racket is a third Lisp/Scheme REPL
    mitscheme = ''${pkgs.rlwrap}/bin/rlwrap ${pkgs.mitscheme}/bin/scheme'';
    juliascheme = ''${pkgs.rlwrap}/bin/rlwrap julia --lisp'';
    # end of REPLs
    l = "exa";
    ls = "ls --color=auto -F";
    ll = "exa -all --long --header";
    # clean vim (no vimrc and/or plugins)
    cvim = "nvim --clean -N";
    # minimal vim
    mvim = "nvim -u ~/.config/nvim/essential.vim";
    g = "git";
    e = "eval $EDITOR";
    f = ''${pkgs.fzf}/bin/fzf --preview "bat --style=numbers --color=always {} | head -500"'';
    # .. cd-aliases
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    "......" = "cd ../../../../..";
    # u cd-aliases
    u = "cd ..";
    uu = "cd ../..";
    uuu = "cd ../../..";
    uuuu = "cd ../../../..";
    uuuuu = "cd ../../../../..";
    # other cd-aliases
    r = "cd ~/repos";
    p = "cd ~/projects";
    dl = "cd ~/Downloads";
    dotf = "cd ~/projects/config/home-config";
    ds = "cd ~/Documents";
    pnet = "cd ~/projects/dotnet";
    lofus = "cd ~/projects/dotnet/lofus";
    ffv = "cd ~/projects/dotnet/ffv-rtl";
    ffva = "cd ~/projects/dotnet/ffv-rtl-f3f5";

    # This is NOT ideal
    # sessionVariables = {
    #   NIX_PATH = "nixpkgs=${sources.nixpkgs}:\${NIX_PATH}";
    # };

    # This is NOT ideal either (but better). The problem is that HM changes will
    # be a 2-step process:
    #   1) First bump nixpkgs,
    #          niv update nixpkgs   (NOTE: remember to restart your shell to aupdate the hm alias!!!)
    #   2) Second change HM-config.
    # Create alias that add a nixpkgs-path to to NIX_PATH
    # to force home-manager to use pinned version of nixpkgs
    home-manager = "home-manager -I nixpkgs=${sources.nixpkgs}";
    hm = "home-manager -I nixpkgs=${sources.nixpkgs}";
  } // (if builtins.currentSystem == "x86_64-linux" then {
    # Only add an oni2 alias on Linux (on MacOS use "Add to System PATH" via Ctrl+P in the editor)
    # See also https://onivim.github.io/docs/using-onivim/command-line
    oni2="~/bin/OniVim2/Onivim2-x86_64-master.AppImage";
  } else {});
  commonShellScript = ''
    load-secrets() {

      # Credits: https://www.madboa.com/geek/openssl/#how-do-i-base64-encode-something

      secpath="$HOME/.secrets"

      # passphrase file
      passphrase_filename="my-silly-password.txt"
      passphrase_path="$secpath/$passphrase_filename"

      github_pwd_filename="github-pwd.enc"
      github_pwd_path="$secpath/$github_pwd_filename"

      github_grm_token_filename="github-gitreleasemanager-token.enc"
      github_grm_token_path="$secpath/$github_grm_token_filename"

      appveyor_access_token_filename="appveyor-access-token.enc"
      appveyor_access_token_path="$secpath/$appveyor_access_token_filename"

      brf_nuget_apikey_filename="brf-nuget-apikey.enc"
      brf_nuget_apikey_path="$secpath/$brf_nuget_apikey_filename"

      # github_password
      if [[ -f $github_pwd_path && -f $passphrase_path ]]; then
        export GITHUB_PASSWORD=$(openssl enc -d -iter 10000 -pbkdf2 -aes-256-cbc -in $github_pwd_path -pass file:$passphrase_path)
      else
        printf "The github_password environment variable could not be resolved -- you most first generate an encrypted file"
      fi

      # github_access_token
      if [[ -f $github_grm_token_path && -f $passphrase_path ]]; then
        export GITHUB_ACCESS_TOKEN=$(openssl enc -d -iter 10000 -pbkdf2 -aes-256-cbc -in $github_grm_token_path -pass file:$passphrase_path)
      else
        printf "The github_access_token environment variable could not be resolved -- you most first generate an encrypted file"
      fi

      # AppVeyor_AccessToken
      if [[ -f $appveyor_access_token_path && -f $passphrase_path ]]; then
        export APPVEYOR_ACCESSTOKEN=$(openssl enc -d -iter 10000 -pbkdf2 -aes-256-cbc -in $appveyor_access_token_path -pass file:$passphrase_path)
      else
        printf "The AppVeyor_AccessToken environment variable could not be resolved -- you most first generate an encrypted file"
      fi

      # Brf_NuGet_ApiKey
      if [[ -f $brf_nuget_apikey_path && -f $passphrase_path ]]; then
        export BRF_NUGET_APIKEY=$(openssl enc -d -iter 10000 -pbkdf2 -aes-256-cbc -in $brf_nuget_apikey_path -pass file:$passphrase_path)
      else
        printf "The Brf_NuGet_ApiKey environment variable could not be resolved -- you most first generate an encrypted file"
      fi
    }

    hg() { history | grep "$1"; }
    pg() { ps aux | grep "$1"; }

    # switch to using bash/zsh in current shell session (without affecting new terminal windows or anything)
    to_bash() { exec bash --login; }
    to_zsh() { exec zsh --login; }

    # set default shell to bash
    use_bash() {
      if [[ ! $(echo $SHELL) == $(which bash) ]]; then
        chsh -s $(which bash) $(whoami)
      fi
    }

    # set default shell to zsh
    use_zsh() {
      if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh) $(whoami)
      fi
    }

    if [ -e "$HOME/bin" ]; then
      export PATH="$PATH:$HOME/bin"
    fi

    # Racket
    # If you want to install new system links within the "bin", "man"
    # and "share/applications" subdirectories of a common directory prefix
    # (for example, "/usr/local") then enter the prefix of an existing
    # directory that you want to use.
    if [ -e "/usr/racket" ]; then
      export PATH="/usr/racket/bin:$PATH"
    fi

    # we need anaconda's bin dir in our PATH
    if [ -e "$HOME/anaconda3/bin" ]; then
      export PATH="$PATH:$HOME/anaconda3/bin"
    fi

    # we need Cargo's bin directory ($HOME/.cargo/bin) in our PATH
    if [ -e "$HOME/.cargo/bin" ]; then
      export PATH="$PATH:$HOME/.cargo/bin"
    fi

    # we need jill's bin dir (julia version manager) in our PATH (installed via pip/python)
    if [ -e "$HOME/.local/bin" ]; then
      export PATH="$PATH:$HOME/.local/bin"
    fi

    # # Standard ML (smlnj)
    # if [ -e "/usr/local/sml/bin" ]; then
    #   export SMLROOT=/usr/local/sml
    #   export PATH="$PATH:$SMLROOT/bin"
    # fi

    # we need to load nvm (nodejs version manager)
    nvm_dir_var="$([ -z "''${XDG_CONFIG_HOME-}" ] && printf %s "''${HOME}/.nvm" || printf %s "''${XDG_CONFIG_HOME}/nvm")"
    if [ -e "$nvm_dir_var" ]; then
      export NVM_DIR="$nvm_dir_var"
      [ -s "$nvm_dir_var/nvm.sh" ] && \. "$nvm_dir_var/nvm.sh" # This loads/sources nvm
    fi

    # TODO: Can be deleted (HM souces the script in ~/.profile)
    # If you don't want to let Home Manager manage your shell then you will have
    # to manually source the `~/.nix-profile/etc/profile.d/hm-session-vars.sh`
    # NOTE: This picks up enviroment variables defined in enviroment.nix
    #if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
    #  source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    #fi

    if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
      source "$HOME/.nix-profile/etc/profile.d/nix.sh"
      export NIX_PATH=$HOME/.nix-defexpr/channels''${NIX_PATH:+:}$NIX_PATH
    fi

    # ensure home-manager binaries are found before anything else (including /usr/local/bin:/usr/bin:/bin)
    if [ -e "$HOME/.nix-profile/bin" ]; then
      export PATH="$HOME/.nix-profile/bin:$PATH"
    fi

    nix-closure-size() { nix-store -q --size $(nix-store -qR $1 ) | awk '{ a+=$1 } END { print (a / 1024 / 1024 / 1024) "Gi" }'; }

    # Nix-index provides a "command-not-found" script that can print for you the attribute path
    # of unfound commands in your shell.
    source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh

    # I cannot find where these er overridden in my user enviromment!!!!!!
    export VISUAL="code --wait --new-window";
    export EDITOR="code --wait --new-window";
    export GIT_EDITOR="code --wait --new-window";
  '';
in
{
  # Use nix-index provided script
  programs.command-not-found.enable = false;

  # Better to use the systems man package on non-NixOS linux
  # https://github.com/rycee/home-manager/issues/432#issuecomment-434498787
  programs.man.enable = false;
  home.extraOutputsToInstall = [ "man" ];


  # TODO: Migrate ~/.bash_profile from dotfiles over here
  programs.bash = {
    enable = true;
    historyControl = [ "erasedups" ];
    historyFile = "\$HOME/.config/bash/.bash_history";
    historyIgnore = [ "l" "ls" "cd" "exit" ];
    # warning: The option `programs.bash.enableAutojump' defined in
    # `/home/maxfire/projects/config/home-config/home/shells.nix' has been
    # renamed to `programs.autojump.enable'. It is true be deefault!!!!
    # enableAutojump = true;
    sessionVariables = {
      # NOTE: non-BASH-specific environment variables should be placed
      # in environment.nix
    };
    shellOptions = [
      "autocd" "cdspell" "dirspell" "globstar" # bash >= 4
      "cmdhist" "nocaseglob" "histappend" "extglob"];
    shellAliases = commonShellAliases;
    initExtra = ''
      # bash parameter completion for the dotnet CLI
      _dotnet_bash_complete()
      {
        local word=''${COMP_WORDS[COMP_CWORD]}

        local completions
        completions="$(dotnet complete --position "''${COMP_POINT}" "''${COMP_LINE}" 2>/dev/null)"
        if [ $? -ne 0 ]; then
          completions=""
        fi

        COMPREPLY=( $(compgen -W "$completions" -- "$word") )
      }

      complete -f -F _dotnet_bash_complete dotnet

      ${commonShellScript}
    '';
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    autocd = true;              # setopt autocd
    defaultKeymap = "viins";    # bindkey -v (vi mode)
    history = {
      path = "\$HOME/.config/zsh/.zsh_history";
      size = 50000;
      save = 50000;
    };
    initExtraBeforeCompInit = ''
      eval $(${pkgs.coreutils}/bin/dircolors -b ${../dotfiles/LS_COLORS})
      ${builtins.readFile ../dotfiles/pre-compinit.zsh}
    '';
    initExtra = ''
      ${builtins.readFile ../dotfiles/post-compinit.zsh}
      # Use lf to switch directories and bind it to ctrl-o
      # lf (as in "list files") is a terminal file manager written in Go.
      lfcd () {
          tmp="$(mktemp)"
          ${pkgs.lf}/bin/lf -last-dir-path="$tmp" "$@"
          if [ -f "$tmp" ]; then
              dir="$(cat "$tmp")"
              rm -f "$tmp"
              [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
          fi
      }
      bindkey -s '^o' 'lfcd\n'

      # zsh parameter completion for the dotnet CLI
      # See also https://docs.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete
      _dotnet_zsh_complete()
      {
        local completions=("$(dotnet complete "$words")")

        reply=( "''${(ps:\n:)completions}" )
      }

      compctl -K _dotnet_zsh_complete dotnet

      ${commonShellScript}
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
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=3";
    };
    shellAliases = commonShellAliases;
  };

  # Add the necessary integrations to bash and zsh (cd hook, j functions etc)
  programs.autojump.enable = true;
}

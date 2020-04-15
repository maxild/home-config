{ ... }:

{
  # TODO: Migrate ~/.bash_profile from dotfiles over here
  programs.bash = {
    enable = true;
    historyFile = "\$HOME/.config/bash/.bash_history";
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";
      "......" = "cd ../../../../../";
      "ll" = "ls -al";
      "ns" = "nix-shell --command zsh";
    };
    initExtra = ''
      hg() { history | grep "$1"; }
      pg() { ps aux | grep "$1"; }
      cd() { if [[ -n "$1" ]]; then builtin cd "$1" && ls; else builtin cd && ls; fi }
    '';
    sessionVariables = {
      EDITOR = "vim";
    };
    shellOptions = [
      "autocd" "cdspell" "dirspell" "globstar" # bash >= 4
      "cmdhist" "nocaseglob" "histappend" "extglob"];
  };

  xdg.configFile = {
    ".inputrc".source = ../dotfiles/.inputrc;
    # Equivalent to this
    #".inputrc".text = builtins.readFile ./.inputrc;
  };
}

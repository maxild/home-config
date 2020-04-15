{ config, pkgs, ... }:

{

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

}

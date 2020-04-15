{ pkgs, config, ... }:

{
  imports = [
    #./dev/emacs.nix
    ./dev/zsh.nix
    ./dev/bash.nix
    ./dev/git.nix
    ./dev/nix.nix
  ];

  home.file.".editorconfig".source = ./. + "/dotfiles/root.editorconfig";
}

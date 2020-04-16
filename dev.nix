{ pkgs, config, ... }:

{
  imports = [
    #./dev/emacs.nix
    ./dev/term.nix
    ./dev/git.nix
    # TODO: Move all dotfile stuff to XDG
    ./dev/xdg.nix
    ./dev/nix.nix
  ];

  home.file.".editorconfig".source = ./. + "/dotfiles/root.editorconfig";
}

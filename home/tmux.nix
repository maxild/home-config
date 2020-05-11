{ pkgs, ... }:

{
  # terminal multiplexer
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    secureSocket = false;
    # TODO: maybe add this to get nvim to use 256 colors
    #    set -g default-terminal "tmux-256color"
    #terminal = "tmux-256color";
    #terminal = "xterm-256color";
    terminal = "screen-256color";
    clock24 = true;
    extraConfig = builtins.readFile ../dotfiles/tmux;
  };
}

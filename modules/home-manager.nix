{ ... }:

{
  programs.home-manager = {
    # home-manager is run as a standalone tool (not part of darwin-rebuild or nixos-rebuild)
    enable = true;
    path = "${/. + ../vendor/home-manager}";
    #path = "https://github.com/rycee/home-manager/archive/master.tar.gz";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";
}

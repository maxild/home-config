let
  sources = import ./nix/sources.nix;

  # this is the pinned package set
  pkgs = import sources.nixos-20-03 ({
  #pkgs = import sources.nixpkgs ({
    config = import ./nixpkgs/config.nix;
    overlays = import ./nixpkgs/overlays.nix;
  });

in

rec {
  home-manager = pkgs.callPackage ./vendor/home-manager/home-manager {
    path = toString ./vendor/home-manager;
  };

  install = pkgs.callPackage ./vendor/home-manager/home-manager/install.nix {
    inherit home-manager;
  };

  nixos = import ./vendor/home-manager/nixos;
}

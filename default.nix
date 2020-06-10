let
	# niv provided pinned version of nixpkgs
  sources = import ./nix/sources.nix;

  # This is NOT the nixpkgs collection used by our own HM-config (home.nix)
  # This is the nixpkgs used to instantiate the HM executable
  pkgs = import sources.nixpkgs {};

#   # See https://gist.github.com/shanesveller/42385fef750305ce4f02005ea78912e3

#   homeDir = builtins.getEnv "HOME";
#   hm_file = "${homeDir}/.config/nixpkgs/home.nix";

#   # top-level package containing 'home-manager', 'install' and 'nixos' attributes
#   # we only need home-manager field (attr)
#   home-manager = import ./vendor/home-manager {
#     inherit pkgs;
#   };

#   # HM will nix-build this nix expression during build/switch
#   # we need to inject pinned nixpkgs
#   home-manager-data = import ./vendor/home-manager/home-manager/home-manager.nix {
#     inherit pkgs;

#     confPath = hm_file; # HOME_MANAGER_CONFIG
#     confAttr = "";      # HOME_MANAGER_CONFIG_ATTRIBUTE
#   };

#   build-nix-path-env-var = path:
#     builtins.concatStringsSep ":" (
#       pkgs.lib.mapAttrsToList (k: v: "${k}=${v}") path
#     );

#   # NOTE: we do not pin home-manager repo via niv sources
#   nix-path = build-nix-path-env-var {
#     #inherit (sources) home-manager nixpkgs;
#     inherit (sources) nixpkgs;
#   };

#   set-nix-path = ''
#     export NIX_PATH="${nix-path}"
#   '';

#   # make wrapper shell script that injects niv pinned nixpkgs into NIX_PATH
#   hm-deploy = pkgs.writeShellScriptBin "hm-deploy" ''
#     ${set-nix-path}
#     home-manager ''${1-switch} --keep-going --show-trace
#   '';

# in

# {
#   #inherit sourceLinkFarm;

#   bootstrap = pkgs.mkShell {
#     buildInputs = with pkgs; [
#       hm-deploy
#       # import 'home-manager' runCommand derivation
#       home-manager = import ./vendor/home-manager/home-manager {
#         path = toString ./vendor/home-manager;
#       };
#       # The above is equivalent to if not using git sub module
#       #home-manager.home-manager
#     ];
#   };

#   home-manager = home-manager-data.activationPackage;

#   system = pkgs.buildEnv {
#     name = "nix-config-${version}";
#     paths = [
#       #darwin.system
#       home-manager-data.activationPackage
#     ];
#     ignoreCollisions = true;
#   };
# }

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

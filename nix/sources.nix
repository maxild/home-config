let
  # To generate json sources for master branch (refs/heads/master)
  #   $ nix-prefetch-git https://github.com/nixos/nixpkgs.git refs/heads/master > nix/nixpkgs-master.json
  nixpkgsSrc = builtins.fromJSON (builtins.readFile ./nixpkgs-master.json);
  #   $ nix-prefetch-git https://github.com/nixos/nixpkgs-channels.git refs/heads/nixpkgs-unstable > nix/nixpkgs-unstable.json
  nixpkgsUnstableSrc = builtins.fromJSON (builtins.readFile ./nixpkgs-unstable.json);
  #   $ nix-prefetch-git https://github.com/nixos/nixpkgs-channels.git refs/heads/nixos-19.09 > nix/nixos-19-09.json
  nixos1909Src = builtins.fromJSON (builtins.readFile ./nixos-19-09.json);
  #   $ nix-prefetch-git https://github.com/nixos/nixpkgs-channels.git refs/heads/nixos-20.03 > nix/nixos-20-03.json
  nixos2003Src = builtins.fromJSON (builtins.readFile ./nixos-20-03.json);
in
  {
    # this will put the nixpkgs snapshot-revisions (aka sources) into the nix-store
    # The derivations can be stringified into paths using ${...} operator in nix
    nixpkgs = builtins.fetchTarball {
      url    = "https://github.com/NixOS/nixpkgs/archive/${nixpkgsSrc.rev}.tar.gz";
      inherit (nixpkgsSrc) sha256;
    };
    nixpkgs-unstable = builtins.fetchTarball {
      url    = "https://github.com/NixOS/nixpkgs/archive/${nixpkgsUnstableSrc.rev}.tar.gz";
      inherit (nixpkgsUnstableSrc) sha256;
    };
    nixos-19-09 = builtins.fetchTarball {
      url    = "https://github.com/NixOS/nixpkgs/archive/${nixos1909Src.rev}.tar.gz";
      inherit (nixos1909Src) sha256;
    };
    nixos-20-03 = builtins.fetchTarball {
      url    = "https://github.com/NixOS/nixpkgs/archive/${nixos2003Src.rev}.tar.gz";
      inherit (nixos2003Src) sha256;
    };
  }

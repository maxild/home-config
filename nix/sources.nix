let
  # To generate json sources for master branch (refs/heads/master)
  #   $ nix-prefetch-git https://github.com/nixos/nixpkgs.git refs/heads/master > nix/nixpkgs-master.json
  nixpkgsSrc = builtins.fromJSON (builtins.readFile ./nixpkgs-master.json);
  #   $ nix-prefetch-git https://github.com/nixos/nixpkgs-channels.git refs/heads/nixos-19.09 > nix/nixos-19-09.json
  nixos1909Src = builtins.fromJSON (builtins.readFile ./nixos-19-09.json);
in
  {
    # this will put the nixpkgs snapshot-revisions (aka sources) into the nix-store
    # The derivations can be stringified into paths using ${...} operator in nix
    nixpkgs = builtins.fetchTarball {
      url    = "https://github.com/NixOS/nixpkgs/archive/${nixpkgsSrc.rev}.tar.gz";
      inherit (nixpkgsSrc) sha256;
    };
    nixos-19-09 = builtins.fetchTarball {
      url    = "https://github.com/NixOS/nixpkgs/archive/${nixos1909Src.rev}.tar.gz";
      inherit (nixos1909Src) sha256;
    };
  }
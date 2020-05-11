self: super:
let
  nixpkgs = { rev, sha256 }:
    import (super.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      inherit rev sha256;
    }) { config.allowUnfree = true; };
  last-good-neovim = nixpkgs {
    rev = "81461cff5f540c92e5030f62b89ee7b64e85c6df";
    sha256 = "1kpbw9l69ih9qm143vqpja0njg8fll7jrkph01hqyckm1bnxaljr";
  };
in {
  inherit (last-good-neovim) neovim-unwrapped;
}

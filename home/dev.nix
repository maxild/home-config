{ pkgs, ... }:

{
  home.packages = with pkgs; [

    # See also https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md

    #
    # default.nix
    #
    # with import <nixpkgs> {};

    # # wrapper around mkDerivation (getting the right interpreter version)
    # python3Packages.buildPythonPackage {
    #   pname = "pybids"
    #   version = "0.10.2"

    #   src = ./.;

    #   # normally we use buildInputs, but python is a little different
    #   propagatedBuildInputs = with python3Packages; [
    #     numpy
    #     # etc...
    #   ];

    #   checkInputs = with python3Packages; [
    #     pytest
    #     mock
    #   ]

    #   doCheck = true | false;
    #   checkPhase = ''
    #     pytest
    #   '';
    #   pythonImportsCheck = [ "bids" ];
    # }

    #
    # shell.nix
    #
    # nix-shell -A py38
    # with import <nixpkgs> {};

    # let
    #   # wrapper around mkDerivation (getting the right interpreter version)
    #   makeShell = python : (mkShell {
    #     name = "pybids-dev-env"

    #     # this works only if the following packages are available in unstable nipkgs
    #     buildInputs = with python38Packages; [
    #       numpy
    #       # etc...
    #       pytest
    #       mock
    #     ]
    #     # to use package not in nixpkgs, you can drop down to virtualenv
    #     venvDir = "venv${python.version}";
    #     postShellHoot = ''
    #       pip install num3words
    #     '';
    #   });
    # in
    #   {
    #     py37 = makeShell python37;
    #     py38 = makeShell python38;
    #     py39 = makeShell python39;
    #   }

    # NOTE: Another style of dev env
    # with import <nixpkgs> {};
    # buildEnv {
    #   name = "env";
    #   paths = [
    #     (python38.withPackages (ps: with ps; [
    #       (callPackage ./toolz.nix {})
    #       numpy
    #     ]))
    #     graphviz
    #   ];
    # }

    # We start with this
    # python38

    # Only install gcc/clang into shell.nixi
    # Compiling any C library installed with nix does not work unless you use a
    # nix-shell. This is because our gcc package is actually a shell script that
    # receives location of library/header paths through environment variables.
    # These environment variables are only set if you add packages to buildInputs
    # within a shell.nix. You can read more about this at https://nixos.wiki/wiki/C
    #
    # Also read https://github.com/direnv/direnv/wiki/Nix and https://github.com/nix-community/nix-direnv
    #
    #gcc
    #clang

    go

    # IMPORTANT
    # =========
    # I have decided to use rustup (outside nixpkgs) to manage the rust toolchain

    # I am not ready for rust nightlies
    # https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/rust.section.md
    # BUT the disadvantage of this is that the Rust nightly releases are not packaged,
    # and it is quite common in the Rust ecosystem for crates to depend on experimental
    # features and thus the nightly Rust compiler.
    #
    # Then there’s rustup, a tool provided by Rust upstream to manage the Rust tools
    # on your system. This is basically a package manager by itself. It provides the
    # cargo und rustc binaries and dynamically points them to some downloaded version
    # in your home directory. This is probably the best way to get a nightly Rust
    # toolchain, if you don’t mind using a different package management tool.
    #
    # Some more detailed information on rustup on NixOS: The thing is a bit tricky,
    # because the downloaded binaries make some assumptions about system, that are
    # not met on NixOS. Fortunately the rustup packaged in nixpkgs fixes this by
    # patching the downloaded binaries on the fly to work on NixOS.
    #
    #   rustup
    #
    # nixpkgs-mozilla is mostly just a repository containing additional packaging
    # information for Nix on how to obtain the latest Rust tools as binaries and
    # patch them to work on NixOS. This is a bit similar to a PPA on Ubuntu, as
    # it contains additional Nix packages that are not available from the main
    # package sources, nixpkgs.
    #
    # This is mostly useful in cases where you need a nightly release, but also
    # want to use the Nix package manager, for example to share your build environment
    # with collegues or CI workers.
    # The Nix expression required to use it is indeed a bit more complicated involving
    # overlays and stuff. I won’t go into detail here, because using nixpkgs-mozilla
    # should not be necessary in most cases, but this is also described in one of
    # the shell.nix examples on the web.
    #rustc
    #cargo
    #rustfmt
    #rustPackages.clippy # linter
    # Usage: cargo clippy --version
    #clippy # a bunch of lints to catch common mistakes in Rust code
    # NOTE: remember to set
    # export RUST_BACKTRACE = 1

    gnumake
    ctags

    # this is defined in an overlay
    #dotnet-sdk_3_1

    # (with dotnetCorePackages; combinePackages [
    #   sdk_2_1
    #   sdk_3_0
    #   sdk_3_1
    # ])

    mono

    # Powershell Core
    powershell
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    ALTERNATE_EDITOR = "nano";
    # TODO
    #VIM_SOURCE_DIR="$HOME/vim";
    #DOTNET_ROOT="${pkgs.dotnet-sdk_3_1}";
  };
}

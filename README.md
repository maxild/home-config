# Installation

**Prerequisites** : You must have installed the Nix Package Manager on your system. Instructions can be found [here](https://nixos.org/nix/manual/#ch-installing-binary).

First

```bash
git clone https://github.com/maxild/nix-home.git
ln -fs "$PWD/home.nix" "$HOME/.config/nixpkgs/home.nix"
chmod +x install.sh
./install.sh
```

Then edit the `home.nix` file and run

```bash
./switch.sh
```

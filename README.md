# Installation

**Prerequisites** : You must have installed the Nix Package Manager on your system. Instructions can be found [here](https://nixos.org/nix/manual/#ch-installing-binary).

## Install home-manager command

The file `~/.config/nixpkgs/home.nix` contains the declarative specification of your Home Manager configuration. The install command below will symlink a machine-specific file into `~/.config/nixpkgs/home.nix`.

```bash
git clone https://github.com/maxild/home-config.git
git submodule update --init)
git submodule update --remote
chmod u+x install.sh
./install.sh machines/[macbook|ubuntu_wsl|popos].nix
```

## Change the default shell to ZSH

```bash
sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)
```

The change requires a reboot in order for SHELL variable to change.

## Configure user environment

Edit the `common.nix` file (it play the role of a `home.nix` file, and imports a lot of other modules) and run

```bash
home-manager switch
```

## Vendor

To update the home-manager release-20.03 branch

```bash
git submodule update --remote
```

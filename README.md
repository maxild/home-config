# Installation

**Prerequisites** : You must have installed the Nix Package Manager on your system. Instructions can be found [here](https://nixos.org/nix/manual/#ch-installing-binary).

## Install home-manager command

The file `~/.config/nixpkgs/home.nix` contains the declarative specification of your Home Manager configuration. The install command below will symlink a machine-specific file into `~/.config/nixpkgs/home.nix`.

```bash
git clone https://github.com/maxild/home-config.git
git submodule update --init
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

## Notes

* When you are using a distribution other than NixOS, then your desktop
environment (GNOME) will be looking for your applications in
`/usr/share/applications` while those installed with Nix are actually
in ~/.nix-profile/share/applications.

It is important to note that the path needs to be added to this variable before your desktop
manager is started. How this is accomplished will vary by distro and/or login manager.

Idea for creating symlinks, if XDG_DATA_DIRS cannot be picked up by GNOME
find ~/nix-profile/share/applications -type l -exec ln -s $HOME/{} $HOME/.local/share/applications

NOTE: Place desktop file in the /usr/share/applications directory so that it is accessible by everyone, or
in ~/.local/share/applications if you only wish to make it accessible to a single user.

Add ~/.nix-profile/share to XDG_DATA_DIRS in order for GNOME to pickup desktop files
export XDG_DATA_DIRS="$HOME/.nix-profile/share:${XDG_DATA_DIRS}"

TODO: Symlink ~/.nix-profile/share/applications into ~/.local/share/applications
TODO: patch/overlay/add the postInstall phase such that desktop file have absolute path to Icon file:
            sed -re 's@Icon=bcompare(dev)?[0-9.]*-?@Icon=@' -i "$out/share/applications/"*.desktop
 Update the path to the kitty icon in the kitty.desktop file
    sed -i "s/Icon\=kitty/Icon\=\/home\/$USER\/.local\/kitty.app\/share\/icons\/hicolor\/256x256\/apps\/kitty.png/g" \
         ~/.local/share/applications/kitty.desktop

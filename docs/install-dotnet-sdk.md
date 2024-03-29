## Ubuntu/Popos 21.10 Guidelines

See https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu

```
$ wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
$ sudo dpkg -i packages-microsoft-prod.deb
$ rm packages-microsoft-prod.deb
```

NOTE: Only path to `packages-microsoft-prod.deb` has a changed version.

## Ubuntu/Popos 22.04 Guidelines

See also https://github.com/dotnet/core/issues/7038

See also more importantly https://github.com/dotnet/core/issues/7699 about
two fifferent apt feeds for installing .NET 6 SDK on LInux. I prefer PMC feed
because this is the [only way](https://github.com/dotnet/core/issues/7699#issuecomment-1222180915)
to install feature branch (n in `6.0.nxx` releases used by vs2022 on Windows).

Add the repo:

```bash
$ wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
$ sudo dpkg -i packages-microsoft-prod.deb
$ rm packages-microsoft-prod.deb
```
Run Update and also install tool for HTTPS support

```bash
$ sudo apt update
$ sudo apt install -y apt-transport-https
```

To install/update SDK using APT run:

```
$ sudo apt install dotnet-sdk-6.0
```

To remove SDK using APT run:

```
$ sudo apt remove dotnet-sdk-6.0
```

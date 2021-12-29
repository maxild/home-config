Newer kernel versions have issues with building kernel modules VMMON and VMNET.
This will/can occur with the 5.4.x kernel series that are included in the 20.04 Focal Fossa release.

```bash
$ echo $(uname -r)
5.15.5-76051505-generic
```

```bash
$ vmware-installer -l
Product Name         Product Version
==================== ====================
vmware-player        16.1.2.17966106
```

```bash
apt search linux-headers-$(uname -r)
Sorting... Done
Full Text Search... Done
linux-headers-5.15.5-76051505-generic/hirsute,now 5.15.5-76051505.202111250933~1638201579~21.04~09f1aa7 amd64 [installed]
  Linux kernel headers for version 5.15.5 on 64 bit x86 SMP
```

So I have kernel version `5.15.5` and player version `16.1.2`.

Below is a work-around for this issue derived from the great work being maintained
by [Michael Kubecek](https://github.com/mkubecek/vmware-host-modules).

## Procedure

There are two basic methods:

1. Build the modules from source and install them ourselves (`make` and `make install`).

```bash
$ make
$ sudo make install
```

2. Replace VMware provided source tarballs with patched ones and let it use its own
`vmware-modconfig` tool.

```bash
$ tar -cf vmmon.tar vmmon-only
$ tar -cf vmnet.tar vmnet-only
$ sudo cp -v vmmon.tar vmnet.tar /usr/lib/vmware/modules/source/
$ sudo vmware-modconfig --console --install-all
```

The last two commands require root privileges.

## Detailed Procedure

```bash
$ ghq get https://github.com/mkubecek/vmware-host-modules.git
```

Branch "master" cannot be used to build modules, it contains only common
files so that changes in them can be merged into all other branches easily.
To get actual sources, checkout a "real" branch, e.g.

```bash
$ git checkout player-16.1.2
```

In local checked out repository, the replacement tarballs can be created
with

```bash
$ make tarballs
```

This command creates files `vmmon.tar` and `vmnet.tar` in the root,
which can be used to replace the original tarballs provided with the
VMware product.

Run

```bash
$ tar -cf vmmon.tar vmmon-only
$ tar -cf vmnet.tar vmnet-only
```

to create the tarballs

```bash
$ find -name "*.tar"
./vmnet.tar
./vmmon.tar
```

Then replace the original ones provided by VMware

```bash
# backup by renaming the original tarballs
$ sudo mv /usr/lib/vmware/modules/source/vmmon.tar /usr/lib/vmware/modules/source/vmmon.tar.backup
$ sudo mv /usr/lib/vmware/modules/source/vmmon.tar /usr/lib/vmware/modules/source/vmmon.tar.backup
```

Check the existence of the backup tarballs

```bash
$ ls -al /usr/lib/vmware/modules/source/
total 2260
drwxr-xr-x 2 root root    4096 Dec 17 12:10 ./
drwxr-xr-x 3 root root    4096 Aug 16 12:20 ../
-rw-r--r-- 1 root root 1536000 Aug 16 12:20 vmmon.tar.backup
-rw-r--r-- 1 root root  768000 Aug 16 12:20 vmnet.tar.backup
```

```bash
# replace by copying
$ sudo cp ./vmmon.tar /usr/lib/vmware/modules/source/vmmon.tar
$ sudo cp ./vmnet.tar /usr/lib/vmware/modules/source/vmnet.tar
```

Once patched tarballs are installed, you can rebuild the modules as usual:

```bash
$ sudo vmware-modconfig --console --install-all
```

or let the GUI run the command for you.

Replacing the original tarballs prevents having to rebuild and install the
modules manually with every new kernel version. However, once the VMware
product is upgraded or reinstalled, tarballs are replaced so that if the
new VMware version doesn't build/work with a recent kernel, you still need
to repeat the process. The same also holds if there is a new kernel which
requires updated version of the patches.

## Issues

https://github.com/mkubecek/vmware-host-modules/issues/109

made branch and uncommented code!!!!!!

# Devuan 4 Chimaera Release Notes

## Index

 - Introduction
 - New in this Release
 - Getting Devuan 4 Chimaera
 - Upgrading to Devuan 4 Chimaera
 - Notes on Specific Packages and Issues
   - exim
   - su
   - podman
   - wicd
   - Blank Display on Ryzen and other recent AMD CPUs
   - Xfce missing application menu icons
 - Devuan Package Repositories
 - Non-free firmware
 - Devuan package information pages
 - Reporting bugs


## Introduction

This document includes technical notes relevant to Devuan 4 Chimaera.

Devuan 4 Chimaera is based on Debian 11 Bullseye. Much of the information in
[Debian's Release Notes](https://www.debian.org/releases/bullseye/releasenotes)
is relevant and useful. They should be consulted alongside this document.

More information and support on specific issues can be obtained by:

- subscribing to the [DNG mailing
  list](https://mailinglists.dyne.org/cgi-bin/mailman/listinfo/dng)

- visiting the [Devuan user forum](https://dev1galaxy.org)

- asking on one of the [Devuan IRC channels](irc://irc.libera.chat) on libera.chat:

  * `#devuan` - general discussion and support about Devuan
  * `#devuan-arm` - specific support for ARM


## New in this Release
### Accessibility

The installer for Devuan 4 Chimaera is based on the Debian 11 installer. This
means that the procedures described on Debian's [wiki accessibility
page](https://wiki.debian.org/accessibility#Debian_installer_accessibility) for
starting the Debian installer with software speech, hardware speech synthesizer
or a refreshable braille display, also apply to the Devuan installer.

New in Devuan 4 Chimaera is the ability to install a desktop environment without
also installing pulseaudio in the installed system. This enables speech
synthesis in both a graphical and console session at the same time. This
configuration is created by the task-speech-accessibility and
devuan-speech-dispatcher-config-override packages which are installed by default
when the "Install with Speech Synthesis" option ("`s <enter>`" on BIOS systems,
"`s`" on UEFI systems at the boot prompt) is selected.

If you are installing a console only system and do not require this
compatibility you may choose to disable task-speech-accessibility which will
prevent installing orca with its graphical dependencies.

Note that slim (the default Display Manager for xfce) is not accessible. Be sure
to install lightdm or gdm3 if you require an accessible Display Manager.

### Desktops and Display Managers

Improved support for elogind means that virtually all desktops[1] and display
managers in Debian are now also available in Devuan. Newly available display
managers in Devuan 4 Chimaera include gdm3 and sddm. The lxde desktop is also a
new addition.

[1] parl requires systemd and is not available.

## Getting Devuan 4 Chimaera

Devuan 4 Chimaera is available for i386, amd64, armel, armhf, arm64 and ppc64el
architectures.

Installer isos and live CDs for i386 and amd64 are [available for
download](http://files.devuan.org/devuan_chimaera/) at
http://files.devuan.org/devuan_chimaera/.

Mini isos and other specialist installation media for all release architectures
are available from
http://deb.devuan.org/devuan/dists/chimaera/main/installer-{ARCH}/current/images/.

Please consider using one of the many [mirrors](https://devuan.org/get-devuan),
listed at [https://devuan.org/get-devuan](https://devuan.org/get-devuan).

Detailed instructions on how to use each image are available in the
corresponding `README.txt` file. The `SHA256SUMS` of each set of images is
signed by the developer in charge of the build. The fingerprints of [GPG keys of
all Devuan developers]( https://devuan.org/os/team) are listed at
[https://devuan.org/os/team](https://devuan.org/os/team).

In order to check that the images you downloaded are genuine and not
corrupted, you should:

- download the image(s)
- download the corresponding `SHA256SUMS` and `SHA256SUMS.asc` files in the same
  folder
- verify the checksums by running:

  > `sha256sum -c SHA256SUMS`

  (it could complain about missing files, but should show an "OK" close to the
  images you have actually downloaded)

- verify the signature running:

  > `gpg --no-default-keyring --keyring ./devuan-devs.gpg --verify SHA256SUMS.asc`

  (assuming that you have put the GPG keys in the keyring named
   `devuan-devs.gpg`. YMMV)

The `devuan-devs.gpg` keyring is provided only for convenience. The most correct
procedure to verify that the signatures are authentic is by downloading the
relevant public keys from a trusted keyserver, double-check that the fingerprint
of the key matches that of the developer reported on
[https://devuan.org/os/team](https://devuan.org/os/team) and then use that key
for verification.

### Docker images

[Unofficial docker
images](https://hub.docker.com/r/dyne/devuan/tags?page=1&ordering=last_updated )
for all Devuan releases including Devuan 4 Chimaera are also available. They are
prepared and supported by paddy-hack and jaromil and are updated daily.

Related documentation is also available:

- [https://github.com/dyne/docker-devuan-builds](https://github.com/dyne/docker-devuan-builds)
- [https://gitlab.com/paddy-hack/devuan/](https://gitlab.com/paddy-hack/devuan/)


## Upgrading to Devuan 4 Chimaera

Direct and easy upgrade path from Devuan Chimaera and migration path from Debian
Bullseye to Devuan 4 Chimaera are [available]( https://devuan.org/os/install) at
[https://devuan.org/os/install](https://devuan.org/os/install).

If you are already on Chimaera, run this command to get to the
current release version:

> `apt-get update && apt-get upgrade && apt-get dist-upgrade`

## Notes on Specific Packages and Issues
### exim 4.94

Please consider the version of exim in Devuan 4 Chimaera a *major* exim
upgrade. It introduces the concept of tainted data read from untrusted sources,
like e.g. message sender or recipient. This tainted data (e.g. `$local_part` or
`$domain`) cannot be used among other things as a file or directory name or
command name.

This will break configurations which are not updated accordingly. Old Debian
exim configuration files also will not work unmodified; the new configuration
needs to be installed with local modifications merged in.

Typical nonworking examples include:

- Delivery to `/var/mail/$local_part`.

	Use `$local_part_data` in combination with `check_local_user`.

- Using

	`data = ${lookup{$local_part}lsearch{/some/path/$domain/aliases}}`

	instead of

	`data = ${lookup{$local_part}lsearch{/some/path/$domain_data/aliases}}`

	for a virtual domain alias file.

The basic strategy for dealing with this change is to use the result of a lookup
in further processing instead of the original (remote provided) value.

To ease upgrading there is a new main configuration option to temporarily
downgrade taint errors to warnings, letting the old configuration work with the
newer exim. To make use of this feature add

	.ifdef _OPT_MAIN_ALLOW_INSECURE_TAINTED_DATA
     allow_insecure_tainted_data = yes
    .endif

to the exim configuration (e.g. to `/etc/exim4/exim4.conf.localmacros`) before
upgrading and check the logfile for taint warnings. This is a temporary
workaround which is already marked for removal on introduction.

### su

The behaviour of su changed in Devuan 3 Beowulf. These changes persist in Devuan
4 Chimaera. Use  `su -` to get root's path or use the full path to commands if
you use only `su`. See the following for more information:
- [https://www.debian.org/releases/buster/amd64/release-notes/ch-information.en.html#su-environment-variables](https://www.debian.org/releases/buster/amd64/release-notes/ch-information.en.html#su-environment-variables)
- [https://wiki.debian.org/NewInBuster](https://wiki.debian.org/NewInBuster)
- [https://bugs.debian.org/905564](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=905564)

### podman

Debian's podman package only works on Devuan after reconfiguration. The easiest
way to achieve this is to install the debian-podman-config-override package
which sets suitable defaults for Devuan systems.

### wicd

Wicd is no longer available in Devuan 4 Chimaera having been removed from Debian
Bullseye because of it's dependency on python2 which is now obsolete.

Alternative network managers are available:

- connman (default for lxde)
- network-manager (default for xfce, mate, cinnamon and kde via plasma-nm)
- cmst (default for lxqt)
- ifupdown (configuration guide
  [here](https://git.devuan.org/devuan/installer-iso/raw/branch/wip/docs/docs/docs/network-configuration.html)
  or locally on the [installer isos](network-configuration.html))

### Blank Display on Ryzen and other recent AMD CPUs

If you have a Ryzen or other new AMD CPUs and find that the system boots to black
screen, installation of the firmware-amd-graphics package from the non-free
repository is required to fix the issue.

### Xfce missing application menu icons

If, after upgrading from Devuan 3 Beowulf, Xfce application menu icons are
missing, run the command

> `xfconf-query -c xsettings -p /Gtk/MenuImages -t bool -s true --create `

which will recreate the required default configuration.

[Further information](https://forum.xfce.org/viewtopic.php?id=15085):
https://forum.xfce.org/viewtopic.php?id=15085.

## Devuan Package Repositories

Thanks to the support of many volunteers and donors, Devuan has a network of
package repository mirrors.  The mirror network is accessible using the FQDN
[deb.devuan.org](http://deb.devuan.org).

Starting from Devuan 2.0 ASCII, users should exclusively use
[deb.devuan.org](http://deb.devuan.org) in their `sources.list` file, e.g.:

	deb http://deb.devuan.org/merged chimaera main
	deb http://deb.devuan.org/merged chimaera-security main
	deb http://deb.devuan.org/merged chimaera-updates main
	deb http://deb.devuan.org/devuan chimaera-proposed main


Along with the above URLs, the repositories are also accessible
using the Tor network, by using our hidden service address:

	deb tor+http://devuanfwojg73k6r.onion/merged chimaera main
	deb tor+http://devuanfwojg73k6r.onion/merged chimaera-security main
	deb tor+http://devuanfwojg73k6r.onion/merged chimaera-updates main
	deb tor+http://devuanfwojg73k6r.onion/devuan chimaera-proposed main

More information is available at
[https://devuan.org/os/packages](https://devuan.org/os/packages).

All the mirrors contain the full Devuan package repository (all the Devuan
releases and all the suites). They are synced every 30 minutes from the main
Devuan package repository (`pkgmaster.devuan.org`) and are continuously checked
for sanity, integrity, and consistency. The package repository network is
accessed through a DNS Round-Robin.

The updated list of mirrors belonging to the network is available at
[http://pkgmaster.devuan.org/mirror_list.txt](http://pkgmaster.devuan.org/mirror_list.txt).

Users could also opt for directly accessing one of the mirrors in that
list using the corresponding BaseURL.

IMPORTANT NOTE: The package mirrors at [deb.devuan.org](http://deb.devuan.org)
are signed with the following GPG key:

	pub   rsa4096 2017-09-04 [SC] [expires: 2022-09-03]
	      E032601B7CA10BC3EA53FA81BB23C00C61FC752C
	uid  [ unknown] Devuan Repository (Amprolla3 on Nemesis
	              <repository@devuan.org>)
	sub   rsa4096 2017-09-04 [E] [expires: 2022-09-03]

The key is included in the devuan-keyring package. In order to use
[deb.devuan.org](http://deb.devuan.org), you must have
`devuan-keyring_2017.10.03` or higher.

IMPORTANT NOTE: Devuan has discontinued the original set of Devuan mirrors
formerly available at `auto.mirror.devuan.org` and `{CC}.mirror.devuan.org`. As
a consequence, users should *only* use the new set of mirrors via
[deb.devuan.org](http://deb.devuan.org).


## Non-free firmware

All Devuan 4 Chimaera installation media make non-free firmware packages
available at install time. In the majority of the cases, these packages are
needed (and will be installed) only if your hardware (usually wifi adapter)
requires them. It is possible to avoid the automatic installation and loading of
needed non-free firmware by choosing the "Expert install" option in the
installation menu.

Devuan 4 Chimaera desktop-live and minimal-live images come with non-free
firmware packages pre-installed. You have the option of removing those non-free
firmware packages from the desktop-live and minimal-live after boot, using the
`remove_firmware.sh` script available under `/root`.


## Devuan package information pages

Devuan provides a service to display information about all the packages
available in Devuan. This can be accessed at [https://pkginfo.devuan.org](
https://pkginfo.devuan.org).

It is possible to search for package names matching a set of keywords, and to
visualise the description, dependencies, suggestions and recommendations of each
package.

## Reporting bugs

No piece of software is perfect. And acknowledging this fact is the
first step towards improving our software base.

Devuan strongly believes in the cooperation of the community to find, report and
solve issues. If you think you have found a bug in a Devuan package, please
report it to [https://bugs.devuan.org](https://bugs.devuan.org).

The procedure to report bugs is quite simple: install and run `reportbug`, a
tool that will help you compiling the bug report and including any relevant
information for the maintainers.

`reportbug` assumes than you have a properly configured Mail User Agent that can
send emails (and that it knows about). If this is not the case, you can still
prepare your bug report with `reportbug`, save it (by default reportbug will
save the report under `/tmp`), and then use it as a template for an email to
[submit@bugs.devuan.org](mailto:submit@bugs.devuan.org).

(NOTE: Devuan does not provide an open SMTP relay for `reportbug`
yet. If you don't know what this is about, you can safely ignore this
information).

When the bug report is processed, you will receive an email
confirmation indicating the number associated to the report.

Before reporting a bug, please check whether the very same problem has
been already experienced and reported by other users.

In general, issues with Devuan's own forked packages should be reported to
[Devuan's BTS](https://bugs.devuan.org). For unforked packages, bugs should
usually be fixed in Debian. `reportbug` can report issues directly to [Debian's
BTS](https://bugs.debian.org) by using the `-B debian` option.

# Devuan 6 Excalibur Release Notes

## Index

 - Introduction
 - New in this Release
     + Merged-/usr is compulsory
 - Getting Devuan 6 Excalibur
 - Upgrading to Devuan 6 Excalibur
 - Notes on Specific Packages and Issues
     + Reduced support for i386
     + Support for /run/utmp
     + Changes to cdrom set
 - Devuan Package Repositories
 - Non-free-firmware
 - Devuan package information pages
 - Reporting bugs


## Introduction

This document includes technical notes relevant to Devuan 6 Excalibur.

Devuan 6 Excalibur is based on Debian 13 Trixie. Much of the information in
[Debian's Release Notes](https://www.debian.org/releases/trixie/releasenotes)
is relevant and useful. They should be consulted alongside this document.

More information and support on specific issues can be obtained by:

- subscribing to the [DNG mailing
  list](https://mailinglists.dyne.org/cgi-bin/mailman/listinfo/dng)

- visiting the [Devuan user forum](https://dev1galaxy.org)

- asking on one of the [Devuan IRC channels](irc://irc.libera.chat) on libera.chat:

  * `#devuan` - general discussion and support about Devuan
  * `#devuan-arm` - specific support for ARM


## New in this Release
### Merged-/usr is compulsory

A [merged-/usr](https://wiki.debian.org/UsrMerge) filesystem is obligatory. If
you are upgrading from daedalus ensure you have [complied with this
requirement](#upgrading-to-devuan-6-excalibur) *before* upgrading.

## Getting Devuan 6 Excalibur

Devuan 6 Excalibur is available for i386, amd64, armel, armhf, arm64, ppc64el and 
riscv64 architectures. However, the i386 packages don't include a linux-image. See
https://www.debian.org/releases/stable/release-notes/issues.en.html#reduced-support-for-i386
for details.

Installer isos and live CDs for amd64 are [available for
download](http://files.devuan.org/devuan_excalibur/) at
http://files.devuan.org/devuan_excalibur/.

Mini isos and other specialist installation media for all release architectures
are available from
http://deb.devuan.org/devuan/dists/excalibur/main/installer-{ARCH}/current/images/.

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

Official Devuan Docker container images are [available from the Docker
Hub](https://hub.docker.com/u/devuan).  These images are updated as needed for
all maintained releases.  To get the latest image for Excalibur execute

> `docker pull devuan/devuan:excalibur`

For further details on the images, please consult the information on Docker Hub.

## Upgrading to Devuan 6 Excalibur

A direct and easy upgrade path from Devuan Daedalus and a migration path from
Debian Trixie to Devuan 6 Excalibur are [available](
https://devuan.org/os/install) at
[https://devuan.org/os/install](https://devuan.org/os/install). Note that it is
essential to have a merged-/usr filesystem *before* attempting the upgrade. You
*must* install the usrmerge package in Daedalus first.

> `apt-get install usrmerge`

If you already have Excalibur installed, run this command to get to the current
release version:

> `apt-get update && apt-get upgrade && apt-get dist-upgrade`

## Notes on Specific Packages and Issues

### Reduced support for i386

There is no i386 installer iso for Devuan 6 Excalibur, following Debian's
choice to remove their official i386 kernel and installer.

### Support for /run/utmp

Support for login(8) registering sessions in /run/utmp has been restored.
Excalibur is expected to be EOL well before any year 2038 problem manifests.

### Changes to cdrom set

The CD set has changed slightly to form installation choices in the
following ways:

  * Firstly install a "minimal" server (or non-desktop) system by
    using CD-1. Thereafter:

    + Use CD-2 (only) for a server (or non-desktop) installation.

    + Use CD-2, CD-3 and CD-4 for a MATE or XFCE desktop.

    + Use CD-2, CD-3 and CD-5 for an LXDE or LXQt desktop.

The other desktops, KDE and Cinnamon, have too many packages to fit
onto even their own CD size ISOs If you want one of those you are
adviced to rather use either the "netinstall" ISO for on-line
installation, or the "desktop" ISO for off-line installation.

## Devuan Package Repositories

Thanks to the support of many volunteers and donors, Devuan has a network of
package repository mirrors.  The mirror network is accessible using the FQDN
[deb.devuan.org](http://deb.devuan.org).


	deb http://deb.devuan.org/merged excalibur main
	deb http://deb.devuan.org/merged excalibur-security main
	deb http://deb.devuan.org/merged excalibur-updates main
	deb http://deb.devuan.org/devuan excalibur-proposed main


Along with the above URLs, the repositories are also accessible
using the Tor network, by using our hidden service address:

	deb tor+http://devuanfwojg73k6r.onion/merged excalibur main
	deb tor+http://devuanfwojg73k6r.onion/merged excalibur-security main
	deb tor+http://devuanfwojg73k6r.onion/merged excalibur-updates main
	deb tor+http://devuanfwojg73k6r.onion/devuan excalibur-proposed main

More information is available at
[https://devuan.org/os/packages](https://devuan.org/os/packages).

All the mirrors contain the full Devuan package repository (all the Devuan
releases and all the suites). They are synced every 30 minutes from the main
Devuan package repository (`pkgmaster.devuan.org`) and are continuously checked
for sanity, integrity, and consistency. The package repository network is
accessed through a DNS Round-Robin.

The updated list of mirrors belonging to the network is available at
[http://pkgmaster.devuan.org/mirror_list.txt](http://pkgmaster.devuan.org/mirror_list.txt).

If you wish to use a geographically local mirror, you can use
http://${CC}.deb.devuan.org where ${CC} is the CountryCode. If no mirror is
available in that country the URL will still work, although there will be no
advantage.

Users could also opt for directly accessing one of the mirrors in that
list using the corresponding BaseURL.

IMPORTANT NOTE: The package mirrors at [deb.devuan.org](http://deb.devuan.org)
are signed with the following GPG key:

	pub   rsa2048 2014-12-02 [SC]
    	  	72E3CB773315DFA2E464743D94532124541922FB
	uid   Devuan Repository (Primary Devuan signing key) <repository@devuan.org>
	sub   rsa2048 2014-12-02 [E]
	sub   rsa4096 2016-04-26 [S]

The key is included in the current [devuan-keyring package](http://pkginfo.devuan.org/devuan-keyring).


## Non-free firmware

All Devuan 6 Excalibur installation media make non-free firmware packages
available at install time. In the majority of the cases, these packages are
needed (and will be installed) only if your hardware (usually wifi adapter)
requires them. It is possible to avoid the automatic installation and loading of
needed non-free firmware by choosing the "Expert install" option in the
installation menu.

Devuan 6 Excalibur desktop-live and minimal-live images come with non-free
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
usually be fixed in Debian. `reportbug` handles this and sends to the correct
BTS by default. You can override the choice that `reportbug` offers and report
issues directly to [Debian's BTS](https://bugs.debian.org) by using the `-B
debian` option.

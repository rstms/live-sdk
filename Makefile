# live-sdk: devuan iso build scripts
# forked from devuan/live-sdk
#

packages = \
  cgpt \
  debootstrap \
  git \
  gpm \
  live-boot \
  parted \
  squashfs-tools \
  syslinux-common \
  xorriso \
  xz-utils \
  zsh 

help:
	@echo "make desktop | make minimal | make custom"

depends:
	[ -e ~/.zshrc ] || zsh -ic 'echo zsh configured'
	# configure no-password sudo
	sudo sed -i -e '/^%sudo.*) ALL$$/s/ALL$$/NOPASSWD: ALL/' /etc/sudoers
	sudo ls /root
	sudo apt -y update
	sudo apt -y install $(packages)
	

update:
	git submodule update --init --recursive --checkout

desktop:
	logged zsh -fc 'source sdk && load devuan devuan-desktop-live amd64 && build_iso_dist'

minimal:
	logged zsh -ic 'source sdk; load devuan devuan-minimal-live amd64; build_iso_dist'

custom:
	logged zsh -ic 'source sdk; load devuan devuan-desktop-live amd64; build_iso_dist'

clean:
	@echo cleaning

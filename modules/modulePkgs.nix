{ pkgs, ... }:

{
	programs.firefox.enable = true;
	environment.systemPackages = with pkgs; [
	# this sounds like a reasonable way of splitting packages: tty, tui, gui, plugin, daemon/service and commands (coreutils, etc)

	#######
	# tty #
	#######
	# kbd
	vulkan-tools
	bubblewrap
	clinfo
	exfatprogs
	git
	coreutils
	busybox
	pciutils
	libnotify
	# mapscii
	yubikey-manager
	networkmanager
	SDL2
	ffmpeg
	appimage-run	# allows running appimages
	bat				# cat replacement
	eza				# ls replacement
	ncdu			# ncurses disk utility
	skim
	fastfetch
	yt-dlp
	git
	ripgrep
	fd				# search for strings inside of files
	nsh				# search for file names
	#######
	# tui #
	#######
	# amdtop
	nvtopPackages.full
	netop
	rocmPackages.rocminfo
	rocmPackages.rocm-smi
	btop			# Resource monitor with extras
	# btop-rocm		#
	# btop-cuda		#
	superfile		# TUI file manager
	impala			# 🛜 TUI for managing wifi on Linux
	# wiremix 		# Simple TUI audio mixer for PipeWire
	s-tui			# Stress-Terminal UI monitoring tool
	usbtop
	abtop
	micro
	broot
	#######
	# gui #
	#######
	xev
	wev
	beyond-all-reason
	mpv
	vlc
	firefox
	wezterm
	vscodium
	bitwarden-desktop
	discord
	gimp
	krita
	blender
	libreoffice-stable
	zed-editor-fhs
	# feh # requires x11
	imv
	pcmanfm
	pcmanfm-qt
	###########
	# plugins #
	###########
	zsh-autosuggestions
	zsh-syntax-highlighting
	zsh-completions
	];
}

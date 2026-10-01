{ pkgs, ... }:

{
	programs.firefox.enable = true;
	environment.systemPackages = with pkgs; [
	# this sounds like a reasonable way of splitting packages: cli, tui, gui, plugin, daemon/service and commands (coreutils, etc)
	# clarification of classification, tui is any INTERACTIVE application that runs in a cli, cli just returns an output
	#######
	# cli #
	#######
	# kbd
	aria2
	vulkan-tools
	lm_sensors
	powertop
	hd-idle
	mdadm                 # raid manager
	cryptsetup
	bubblewrap
	clinfo
	exfatprogs
	git
	coreutils
	busybox
	pciutils
	libnotify
	yubikey-manager
	networkmanager
	SDL2
	ffmpeg
	appimage-run	        # allows running appimages
	bat				            # cat replacement
	fastfetch
	yt-dlp
	git
	ripgrep
	fd		    		        # search for strings inside of files
	nsh		    		        # search for file names
	eza			    	        # ls replacement
	#######
	# tui #
	#######
	# mapscii
	tuios
	ncdu	    		        # ncurses disk utility
	gdu			    	        # disk utility written in go
	# amdtop
	nvtopPackages.full
	netop
	rocmPackages.rocminfo
	rocmPackages.rocm-smi
	btop			            # Resource monitor with extras
	abtop                 # ai resource monitor
	# btop-rocm		        #
	# btop-cuda		        #
	superfile		          # TUI file manager
	yazi                  # TUI file manager
	impala			          # 🛜 TUI for managing wifi on Linux
	wiremix 		          # Simple TUI audio mixer for PipeWire
	s-tui		  	          # Stress-Terminal UI monitoring tool
	usbtop
	micro
	neovim
	broot                 # fzf with a file tree
	skim                  # fzf but faster
	#######
	# gui #
	#######
	xev                   # x11 event view
	wev                   # wayland event view
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

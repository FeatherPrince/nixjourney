{ pkgs, ... }:

{
	programs.firefox.enable = true;
	environment.systemPackages = with pkgs; [
	# this sounds like a reasonable way of splitting packages: cli, tui, gui, plugin, daemon/service and commands (coreutils, etc)
	# clarification of classification, tui is any INTERACTIVE application that runs in a cli, cli just returns an output
	# where should services go? into their own category?
	#######
	# cli #
	#######
	# kbd
	wl-clipboard          #
	inotify-tools         #
	sox                   #
	nix-output-monitor    #
	nix-fast-build        #
	aria2                 # downloader
	vulkan-tools          #
	lm_sensors            #
	powertop              #
	hd-idle               #
	mdadm                 # raid manager
	cryptsetup            #
	bubblewrap            #
	# is-fast               #
	surfraw               #
	clinfo                #
	duf                   # disk usage free
	exfatprogs            #
	git                   #
	coreutils             #
	busybox               #
	pciutils              #
	libnotify             #
	yubikey-manager       #
	networkmanager        #
	SDL2                  #
	file                  # displays file properties
	ffmpeg                # image and video manipulation
	# appimage-run	        # allows running appimages
	(pkgs.appimage-run.override { extraPkgs = pkgs: [ pkgs.libgpg-error pkgs.SDL2 pkgs.openal ]; }) # adds missing dependency when launching an app through appimage-run
	bat				            # drop in cat replacement
	eza			    	        # modern ls replacement and extension
	zoxide                # modern cd replacement and extension
	ripgrep               # drop in grep replacement: rg
	procs                 # ps aux
	mtr                   #
	shellcheck            #
	tldr                  #
	curl                  #
	jq                    #
	lazydocker            #
	lazygit               #
	lsof                  #
	talkfilters           #
	fastfetch             # systeminfo
	fortune               # fortune cookie
	figlet                # render text as ascii art
	cowsay                # cow... say
	pipes                 # pipes
	cbonsai               # bonsai but in c
	cava                  # console audio visualiser
	yt-dlp                # youtube downloader: yt-dlp
	git                   # version control
	fd		    		        # search for strings inside of files
	nsh		    		        # search for file names
	nvd                   # nix version diff tool
	nh                    # wrapper for nix commands
	nix-tree
	nix-du
	nix-melt
	nix-query-tree-viewer
	nix-visualize
	disko                 # Declarative disk partitioning and formatting using nix
	#######
	# tui #
	#######
	# rexi                  # regex visualisation tool
	# mapscii             #
	# tuios                 #
	# ncdu	    		        # ncurses disk utility
	gdu			    	        # disk utility written in go
	# amdtop              #
	nvtopPackages.full    #
	netop                 #
	rocmPackages.rocminfo #
	rocmPackages.rocm-smi #
	btop			            # Resource monitor with extras
	# abtop                 # ai resource monitor
	# btop-rocm		        #
	# btop-cuda		        #
	superfile		          # TUI file manager
	# yazi                  # TUI file manager
	# nnn                   # TUI file manager
	# mc                    # TUI file manager
	# tuxedo                #
	impala			          # 🛜 TUI for managing wifi on Linux, requires iwd daemon
	bluetui               # TUI for managing bluetooth on Linux
	wiremix 		          # Simple TUI audio mixer for PipeWire
	s-tui		  	          # Stress-Terminal UI monitoring tool
	usbtop                #
	micro                 # text editor
	neovim                # neo vi modern text editor
	# vis                   # vim-like text editor
	# helix                 # a post modern text editor
	# ueberzugpp            # renders images on top of the terminal
	# chafa                 # render images in the terminal using glyphs
	broot                 # fzf with a file tree
	skim                  # fzf but faster
	television            # fzf with a preview
	#######
	# gui #
	#######
	obsidian             #
	# neovide              # neovim but in gui mode
	xev                  # x11 event view
	wev                  # wayland event view
	firefox              # gui web browser
	# brave                # gui web browser
	brave-origin         # gui web browser
	floorp-bin           # gui web browser
	# ungoogled-chromium   # gui web browser
	ladybird           # gui web browser
	# wezterm            # terminal emulator
	# ghostty            # terminal emulator
	# kitty              # terminal emulator
	bitwarden-desktop    # password manager
	dirbuster            #
	discord              #
	inkscape             # vector graphics
	gimp                 # raster graphics
	drawy                # whiteboard
	krita                # raster graphics
	mypaint              # raster graphics
	blender              # 3d modeling, animation, etc
	kdePackages.kdenlive
	obs-studio           # screen capture and livestreaming softwre
	libreoffice-stable   #
	zed-editor-fhs       # integrated development environment
	godot
	# geany              # integrated development environment
	# vscodium           # integrated development environment
	# feh                # x11 image viewer
	imv                  # wayland image viewer
	mpv                  # multimedia player
	kopuz                # audio player
	spotify              # spotify
	# vlc                  # multimedia player
	# anki
	# wireshark
	# pcmanfm            # file manager
	# pcmanfm-qt         # file manager
	thunar               # file manager; file search is INSTANT, pretty neat
	# keepass
	# keepassxc

	#########
	# games # installing games through the package manager is ill advised because then the game version depends on the pacage manager
	#########
	# beyond-all-reason
	# osu-lazer-bin        # package manager manages version
	###########
	# plugins #
	###########
	];
	#########################
	# appimage dependencies # this doesn't work, not sure how to use it, fixed by applying overrides to the appimage package
	#########################
	# programs.nix-ld.enable = true;
	# programs.nix-ld.libraries = with pkgs; [ libgpg-error openal ];
}

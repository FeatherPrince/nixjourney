{ pkgs, ... }:

{
	programs.firefox.enable = true;
	environment.systemPackages = with pkgs; [
	# this sounds like a reasonable way of splitting packages: tty, tui, gui, plugin, daemon/service
	#######
	# tty #
	#######
	yubikey-manager
	networkmanager
	coreutils
	pciutils
	libnotify
	kdePackages.kde-gtk-config
	SDL2
	# ollama
	# ollama-vulkan
	ollama-rocm
	# ollama-cuda
	# ollama-cpu
	appimage-run
	bat
	eza
	ncdu
	skim
	fastfetch
	yt-dlp
	git
	ripgrep
	fd	#	search for strings inside of files
	nsh	#	search for file names
	#######
	# tui #
	#######
	btop
	superfile
	#######
	# gui #
	#######
	beyond-all-reason
	mpv
	firefox
	wezterm
	vscodium
	bitwarden-desktop
	discord
	gimp
	blender
	libreoffice-stable
	zed-editor-fhs
	# feh # requires x11
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

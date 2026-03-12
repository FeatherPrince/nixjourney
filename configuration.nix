# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
    ./wsl.nix
    ./homeManager.nix
  ];

	# Configure keymap in X11
	services = {
    desktopManager = {
      plasma6.enable = true;
      plasma6.enableQt5Integration = true;
    };
    xserver.xkb = {
      layout = "pl";
      variant = "";
    };
    displayManager.ly.enable = true;
  };

	# Configure console keymap
	console.keyMap = "pl2";

	# Enable CUPS to print documents.
	services.printing.enable = true;

  # console = {
  #   font = "ter-v32n";
  #   packages = with pkgs; [ terminus_font ];
  # };

	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "pl_PL.UTF-8";
		LC_IDENTIFICATION = "pl_PL.UTF-8";
		LC_MEASUREMENT = "pl_PL.UTF-8";
		LC_MONETARY = "pl_PL.UTF-8";
		LC_NAME = "pl_PL.UTF-8";
		LC_NUMERIC = "pl_PL.UTF-8";
		LC_PAPER = "pl_PL.UTF-8";
		LC_TELEPHONE = "pl_PL.UTF-8";
		LC_TIME = "pl_PL.UTF-8";
	};

    # services.xserver.excludePackages = with pkgs; [xterm]; 

		environment.systemPackages = with pkgs; [
    feh
		mpv

		bat
		eza
		ncdu
		skim
		fastfetch
		yt-dlp
		btop
    git
    ];
		fonts.packages = with pkgs; [
		nerd-fonts.hack
		nerd-fonts.symbols-only
		nerd-fonts.noto
		noto-fonts
		noto-fonts-color-emoji
		noto-fonts-monochrome-emoji
		noto-fonts-cjk-sans
		noto-fonts-cjk-serif
		openmoji-color
		openmoji-black
		twitter-color-emoji
		twemoji-color-font
		#whatsapp-emoji-font #bugged
		unicode-emoji
		liberation_ttf
		fira-code
		fira-code-symbols
		mplus-outline-fonts.githubRelease
		dina-font
		proggyfonts
		ipafont
		ipaexfont
		weather-icons
#		noto-fonts
#		noto-fonts-lgc-plus
#		noto-fonts-cjk-sans
#		noto-fonts-cjk-serif
#		noto-fonts-color-emoji
#		noto-fonts-emoji-blob-bin
#		noto-fonts-monochrome-emoji
#		nerd-fonts.symbols-only
#		font-awesome
#		font-awesome_4
#		font-awesome_5
	];

  # enable experimental features that are disabled by default
  nix.settings.experimental-features = [ "nix-command" "flakes" ];




  # Enable OpenTabletDriver
  hardware.opentabletdriver.enable = true;
  # Required by OpenTabletDriver
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}

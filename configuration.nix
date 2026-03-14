# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, userName, ... }:

{
	imports = [
	# include NixOS-WSL modules
	# inputs.nixos-wsl.nixosModules.default
	# <nixos-wsl/modules>
	./homeManager.nix

	# either or, importing hardware-config.nix doesn't work on wsl
	# ./wsl.nix
	# or comment out a part of the hardware-config.nix, don't remember what though, teehee
	/etc/nixos/hardware-configuration.nix
	./hyprland.nix
	./locale.nix
	./pkgs.nix
	./fonts.nix
	];

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	services.displayManager.ly.enable = true;
#	services.displayManager.lemurs.enable = true;
#	services.displayManager.sddm.enable = true;
	# services.xserver.enable = true;

 	# services.desktopManager.plasma6.enable = true;
 	# services.desktopManager.plasma6.enableQt5Integration = true;

	programs.bash.promptInit = ''
	export PS1='[\u@\H]\n[\w][\$]'
	'';

	programs.zsh = {
		enable = true;
		autosuggestions.enable = true;
		syntaxHighlighting.enable = true;
		enableCompletion = true;
		shellAliases = {
			cat = "bat";
			ls = "eza --icons=always -X -F=always";
		};
	};

	users.users.${userName} = {
		shell = pkgs.zsh;
		extraGroups = [ "networkmanager" "wheel" ];
	};


	# Configure console keymap

	# Enable CUPS to print documents.
	services.printing.enable = true;

	# services.xserver.excludePackages = with pkgs; [xterm]; 
		nixpkgs.config.allowUnfree = true;


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

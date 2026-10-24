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
	# ./modules/moduleLlama-cpp.nix
	# ./modules/moduleNextcloud.nix
	./hardware-configuration.nix
	../../modules/moduleOllama.nix
	../../modules/moduleOpenTabletDriver.nix
	../../modules/modulePkgs.nix
	../../modules/modulePrograms.nix
	../../modules/modulePython3.nix
	../../modules/moduleAppimage.nix
	../../modules/moduleJellyfin.nix
	../../modulesShared/modulesSystem/locale.nix
	../../modulesShared/modulesSystem/fonts.nix
	../../Profiles/profilePlasma/modulePlasma.nix
	];

	services.getty = {
    helpLine     = "nigtmare";
    # extraArgs    = [];
    # loginProgram = "";
    greetingLine = "cock ball torture";
    # loginOptions = "";
	};

	# these two make sudo and the tty shell give feedback
	# environment.etc."login.defs".text = ''
  #  GETPASS_ASTERISKS yes
	# '';
  security.sudo.extraConfig = "
    Defaults pwfeedback
  ";

  networking.hostName = "nest";
  # networking.wireless.iwd.enable = true;
	# boot.plymouth.enable = true;
	services.kmscon = {
    enable = true;
    config = { };
    # Optional: If you experience systemd-logind seat conflicts,
    # uncomment the line below to disable seat support in kmscon.
    # extraConfig = ''
    #   seat=
    # '';
  };

  environment.variables = {
    COLORTERM   = "truecolor";
    EDITOR      = "nvim";
    VISUAL      = "nvim";
    SOPS_EDITOR = "nvim";
  };
  environment.sessionVariables = {
    XCURSOR_THEME = "Breeze";
    XCURSOR_SIZE  = "24";
  };

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	programs.bash.promptInit =
	''
	export PS1='\n[\u@\H]\n[\w][\$] '
	''; # I'm using "" instead of '''' because I think it looks nicer, fuck you

	# programs.zsh = {
 #    enable = true;
 #    enableCompletion = true;
 #    # zsh-abbr.enable = true;
 #    syntaxHighlighting.enable = true;
 #    oh-my-zsh.enable = true;
 #    # fastSyntaxHighlighting.enable = true;
 #    autosuggestions = {
 #      enable = true;
 #      # async  = true;
 #      # highlight = "fg=#ff00ff,bg=cyan,bold,underline";
 #      strategy    = [ "completion" "history" "match_prev_cmd" ];
 #      extraConfig = {
 #        # "ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE" = "20";
 #        "ZSH_AUTOSUGGEST_BUFFER_MIN_SIZE" = "1";
 #      };
 #    };
 #    shellAliases = {
 #      ls        = "eza --icons=always -F=always";
 #      ll        = "eza --icons=always -F=always -l";
 #      la        = "eza --icons=always -F=always -a";
 #      lt        = "eza --icons=always -F=always --tree";
 #      lla       = "eza --icons=always -F=always -la";
 #      cat       = "bat";
 #      yt-dlp    = "yt-dlp -P $(xdg-user-dir)/yt-dlp";
 #      sops-edit = "sudo SOPS_EDITOR=micro SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key.txt sops ~/nixjourney/secrets/featherlabs.yaml";
 #    };
 #  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
	users.users.${userName} = {
		shell = pkgs.zsh;
		# shell = pkgs.fish;
		extraGroups = [ "networkmanager" "wheel" ];
	};

	# Enable CUPS to print documents.
	services.printing.enable = true;

	# services.xserver.excludePackages = with pkgs; [xterm];
	nixpkgs.config.allowUnfree = true;

	# enable experimental features that are disabled by default
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# use latest kernel version
	boot.kernelPackages = pkgs.linuxPackages_latest;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It's perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "26.05"; # Did you read the comment?
}

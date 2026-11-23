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

	# either or, importing hardware-config.nix doesn't work on wsl
	# ./wsl.nix
	# or comment out a part of the hardware-config.nix, don't remember what though, teehee
	# ./modules/moduleLlama-cpp.nix
	# ./modules/moduleNextcloud.nix
	./hardware-configuration.nix
	# ../../modules/moduleJellyfin.nix
	../../modules/moduleOllama.nix
	../../modules/moduleOpenTabletDriver.nix
	../../modules/modulePkgs.nix
	../../modules/modulePrograms.nix
	../../modules/modulePython3.nix
	../../modules/moduleAppimage.nix
	../../modulesShared/modulesSystem/locale.nix
	../../modulesShared/modulesSystem/fonts.nix
	../../Profiles/profilePlasma/modulePlasma.nix
	];
  ### home block
  # https://github.com/nix-community/home-manager
  # home-manager.extraSpecialArgs = { inherit userName; };
  home-manager.users.${userName} = {
  home.stateVersion = "26.05";
  };
  users.users.${userName} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [

    ];
    shell = pkgs.zsh;
    # shell = pkgs.fish;
  };
  ###

  nix.gc = {
    automatic = true;                      # enables a systemd timer that runs the garbage collector on a schedule.
    dates = "daily";                       # dates sets how often it runs. It uses systemd calendar syntax, so "daily", "weekly", "Sun 03:00", etc. all work.
    options = "--delete-older-than 28d";   # options is passed to nix-collect-garbage. --delete-older-than 30d removes old system generations (and their now-unreferenced store paths) older than 30 days. Without it, only store paths that are already unreferenced get deleted, and old generations keep everything they use alive.
    persistent = true;                     # run a missed job at next boot (default is true)
    randomizedDelaySec = "45min";          # spread out the start time
  };

  services.gvfs.enable    = true;          # Mount, trash, and other functionalities
  services.tumbler.enable = true;          # Thumbnail support for images
  services.udisks2.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [ thunar-archive-plugin thunar-volman thunar-media-tags-plugin ];
  };

  environment.systemPackages = with pkgs; [
    # ... your other packages
    xapp-thumbnailers
    udiskie
  ];

  services.flatpak.enable = true;
  services.flatpak.package = pkgs.flatpak;
  # xdg.portal.enable = false;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

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

  boot.initrd.kernelModules = [ "amdgpu" ]; # "i915", "nouveau", "nvidia" etc.
  hardware.enableRedistributableFirmware = true;

  console = {
    earlySetup = true;
    packages = [ pkgs.terminus_font ];
    font = "ter-v32n";   # or ter-v28n / ter-v24n, depending on screen size
  };

  networking.hostName = "nest";
  # networking.wireless.iwd.enable = true;
	# boot.plymouth.enable = true;

	services.bootvine.settings = {
	  enable = false;
    colors.tree.running-marker = "light-yellow";
    timing.keep-final-frame-for = "500ms";
	};

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
    # this makes sure the correct gpu is selected as the primary one
    # `ls -l /dev/dri/by-path/` # this returns pci address of all gpus
    # `lspci | grep -i vga`     #
    # `vulkaninfo --summary`
    MESA_VK_DEVICE_SELECT = "1002:7590"; # "{vendorID}:{deviceID}" from `vulkaninfo --summary`
    # MESA_VK_DEVICE_SELECT_FORCE_DEFAULT_DEVICE = "1"; # this hides all gpus but the selected ones from vulkan, still visible to the kernel
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

{ pkgs, userName, ... }:

{
	home.username = userName;
	home.homeDirectory = "/home/${userName}";
	home.pointerCursor = {
		gtk.enable = true;
		name = "Adwaita"; # Replace with your preferred cursor theme name
		package = pkgs.gnome.adwaita-icon-theme; # Replace with your cursor package
		size = 24;
	};

  # programs.oh-my-posh.enable = true;
  # programs.oh-my-posh.enableZshIntegration = true;
  # programs.oh-my-posh.useTheme = "";

	programs.bash = {
		enable = true;
	# bashrcExtra commands executed in non all shells including non interactive ones
	# 	bashrcExtra = ''
	# '';
		shellAliases = {
			ls = "eza --icons=always -X -F=always";
			cat = "bat";
			# nrs = "sudo nixos-rebuild switch";
		};
	  # initExtra commands executed in interactive shells
	# 	initExtra = ''
	# '';
	};

	programs.yt-dlp.enable = true;
	programs.yt-dlp.extraConfig = "-P ~/Videos/yt-dlp";
}

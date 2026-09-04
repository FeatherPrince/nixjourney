{ userName, ... }:

{
	home.username = "${userName}";
	home.homeDirectory = "/home/${userName}";

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
			yt-dlp = "yt-dlp -P $(xdg-user-dir VIDEOS)/yt-dlp";
			# nrs = "sudo nixos-rebuild switch";
		};
	  # initExtra commands executed in interactive shells
	# 	initExtra = ''
	# '';
	};

	programs.yt-dlp.enable = true;
	# programs.yt-dlp.extraConfig = ''-P $(xdg-user-dir VIDEOS)/yt-dlp''; # this works, just not when used in the config
}

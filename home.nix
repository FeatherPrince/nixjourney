{ userName, ... }:

{
	home.username = userName;
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
			# nrs = "sudo nixos-rebuild switch";
		};
	  # initExtra commands executed in interactive shells
	# 	initExtra = ''
	# '';
	};
	# services.clipse.enable = true;
	# services.hyprpolkitagent.enable = true;

	programs.yt-dlp.enable = true;
	programs.yt-dlp.extraConfig = "-P ~/Videos/yt-dlp";
	programs.yt-dlp.settings = {
		# color = [
		# 	"stdout:no_color"
		#     "stderr:always"
		# ];
		# downloader = "aria2c";
		# downloader-args = "aria2c:'-c -x8 -s8 -k1M -P ~/Videos/yt-dlp'";
		# embed-subs = true;
		# embed-thumbnail = true;
		# sub-langs = "all";
	};
}

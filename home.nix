{ userName, ... }:

{
	home.username = userName;
	home.homeDirectory = "/home/${userName}";

  programs.bash = {
		enable = true;
  	# bashrcExtra commands executed in non all shells including non interactive ones
		bashrcExtra = ''
	'';
		shellAliases = {
			ls = "eza --icons=always -X -F=always";
      cat = "bat";
			# nrs = "sudo nixos-rebuild switch";
		};
	  # initExtra commands executed in interactive shells
		initExtra = ''
	'';
	};
}
{ userName, ... }:

{
	home.username = userName;
	home.homeDirectory = "/home/feather";

  programs.bash = {
		enable = true;
		bashrcExtra = ''
	#bashrcExtra commands executed in non all shells including non interactive ones
	'';
		shellAliases = {
			ls = "eza --icons=always -X -F=always";
			nrs = "sudo nixos-rebuild switch";
		};
	# there are issues with multi line prompts in WSL
		initExtra = ''
	# initExtra commands executed in interactive shells
	# export PS1='┌[\u@\H][\t]\n└[\w][\$]'
	# export PS1='\[\e[91;2m\]┌[\[\e[0m\]\u@\H\[\e[91;2m\]][\[\e[0m\]\t\[\e[91;2m\]]\n└[\[\e[0m\]\w\[\e[91;2m\]][\[\e[0m\]\$\[\e[91;2m\]]\[\e[0m\]'
	export PS1='\[\e[91m\]┌\[\e[91m\][\[\e[0m\]\u@\H\[\e[91m\]]\[\e[91m\][\[\e[0m\]\t\[\e[91m\]]\n\[\e[91m\]└\[\e[91m\][\[\e[0m\]\w\[\e[91m\]]\[\e[91m\][\[\e[0m\]\$\[\e[91m\]]\[\e[0m\]'
	# exec fish
	'';
	};
}
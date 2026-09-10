{ pkgs, userName, ... }:

{
	services.displayManager.ly.enable = true;
	# services.displayManager.dms-greeter.compositor.name = "mangowc";
	# services.displayManager.dms-greeter.enable = true;
	# programs.dms-shell.systemd.enable = true;
	# programs.dms-shell.enable = true;
	# programs.dms-shell.systemd.restartIfChanged = true;

	programs.mango.enable = true;

	environment.systemPackages = with pkgs; [
		foot
		wmenu
		wl-clipboard
		grim
		slurp
		swaybg
	];
	home-manager.users.${userName} = {
		# xdg.configFile."hypr/hyprland.lua".source = ../configs/hyprland.lua;
	};
}

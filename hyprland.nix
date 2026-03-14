{ pkgs, userName,  ... }:

{
  # environment.sessionVariables.NIXOS_OZONE_WL = "1"; # not used because it's already in the config

	programs.iio-hyprland.enable = true;
	programs.hyprland.enable = true;
	services.hypridle.enable = true;
	programs.hyprland.withUWSM = true;
	programs.hyprlock.enable = true;
	services.displayManager.dms-greeter.compositor.name = "hyprland";
	programs.uwsm.enable = true;
	programs.hyprland.xwayland.enable = true;

# 	services.hyprlauncher.enable = true;
	environment.systemPackages = with pkgs; [
		xdg-desktop-portal-hyprland
		iio-hyprland

		hyprpaper
		hyprpicker
		hypridle
		hyprlock
		xdg-desktop-portal-hyprland
		hyprsunset
		hyprpolkitagent
		hyprsysteminfo
		hyprcursor
		hyprlauncher
	];
	# wayland.windowManager.hyprland.settings = {
	# 
	# };
	home-manager.users.${userName} = {
		services.hyprpolkitagent.enable = true;
		# This creates a symlink at ~/.config/hypr/hyprland.conf
		xdg.configFile."hypr/hyprland.conf".source = ./configs/hyprland.conf;
		xdg.configFile."hypr/hyprlauncher.conf".source = ./configs/hyprlauncher.conf;

		# You can even do it for the whole folder
		#	xdg.configFile."waybar".source = ./configs/waybar-folder;
	};
}

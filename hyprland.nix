{ pkgs, userName,  ... }:

{
	programs.hyprland.withUWSM = true;
	programs.hyprland.enable = true;
	programs.hyprlock.enable = true;
# 	services.hyprlauncher.enable = true;
	environment.systemPackages = with pkgs; [
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
# 	wayland.windowManager.hyprland.settings = {
#
# 	};
home-manager.users.${userName} = {
		services.hyprpolkitagent.enable = true;
    # This creates a symlink at ~/.config/hypr/hyprland.conf
    xdg.configFile."hypr/hyprland.conf".source = ./configs/hyprland.conf;
    xdg.configFile."hypr/hyprlauncher.conf".source = ./configs/hyprlauncher.conf;

    # You can even do it for the whole folder
#     xdg.configFile."waybar".source = ./configs/waybar-folder;
  };
}

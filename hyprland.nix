{ pkgs, ... }:

{
	programs.hyprland.enable = true;
	programs.hyprlock.enable = true;
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
	];
}
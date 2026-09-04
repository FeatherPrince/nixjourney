{ pkgs, userName, config, lib, ... }:

{
	home.username = "${userName}";
	home.homeDirectory = "/home/${userName}";

	home.pointerCursor = {
		gtk.enable = true;
		name = "Adwaita"; # Replace with your preferred cursor theme name
		package = pkgs.adwaita-icon-theme; # Replace with your cursor package
		size = 24;
	};
}

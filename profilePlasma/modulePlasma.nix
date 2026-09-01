{ pkgs,  ... }:

{
	# environment.systemPackages = with pkgs; [
	# 	pkgs.kdePackages.plasma-login-manager
	# ];
	services.desktopManager.plasma6.enable = true;
	services.displayManager.plasma-login-manager.enable = true;
	services.desktopManager.plasma6.enableQt5Integration = true;
	programs.partition-manager.enable = true;
	programs.k3b.enable = true;
	# xdg.portal.extraPortals = [ xdg-desktop-portal-kde ];
}

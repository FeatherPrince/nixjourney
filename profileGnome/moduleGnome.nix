{ pkgs, ... }:

{
	services.displayManager.gdm.enable = true;
	services.desktopManager.gnome.enable = true;

	services.gnome.gnome-keyring.enable = true;
	services.gnome.core-os-services.enable = true;
	services.gnome.evolution-data-server.enable = true;
	services.gnome.gnome-software.enable = true;
	services.gnome.gnome-user-share.enable = true;
	services.gnome.gnome-online-accounts.enable = true;
	services.gnome.gnome-browser-connector.enable = true;
	services.gnome.core-apps.enable = true;
	services.gnome.core-shell.enable = true;
	services.gnome.gnome-settings-daemon.enable = true;
	services.gnome.core-developer-tools.enable = true;
	services.gnome.gnome-initial-setup.enable = true;

	programs.gnome-disks.enable = true;
	programs.evince.enable = true;
	programs.geary.enable = true;
	programs.seahorse.enable = true;
	programs.calls.enable = true;
	programs.nm-applet.enable = true;

	# environment.systemPackages = with pkgs; [
	# 	adwaita-icon-theme
	# 	vanilla-dmz
	# ];

	# adwaita-qt
	# adwaita-qt6
	# adwsteamgtk
	# rewaita
	# nocturne
	# cassette
	# gamepad-mirror
	# firefox-gnome-theme
	# qadwaitadecorations
	# qadwaitadecorations-qt6
}

{ pkgs,  ... }:

{
	services.desktopManager.gnome.enable = true;
	services.gnome.gnome-software.enable = true;
	services.gnome.gnome-user-share.enable = true;
	services.gnome.gnome-online-accounts.enable = true;
	programs.seahorse.enable = true;
	services.gnome.gnome-browser-connector.enable = true;
	services.gnome.core-apps.enable = true;
	services.gnome.core-shell.enable = true;
	services.gnome.gnome-settings-daemon.enable = true;
	services.gnome.core-developer-tools.enable = true;
	programs.evince.enable = true;
	programs.geary.enable = true;
	services.displayManager.gdm.enable = true;
	programs.gnome-disks.enable = true;
	services.gnome.gnome-initial-setup.enable = true;
	programs.calls.enable = true;
	programs.nm-applet.enable = true;
	services.gnome.gnome-keyring.enable = true;
	services.gnome.core-os-services.enable = true;
	services.gnome.evolution-data-server.enable = true;
}

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
	programs.kde-pim.enable = true;
	# xdg.portal.extraPortals = [ xdg-desktop-portal-kde ];

	environment.systemPackages = with pkgs; [
		kdePackages.kcalc
		kdePackages.kde-gtk-config
		kdePackages.kio
		kdePackages.kcoreaddons
		kdePackages.kdbusaddons
	];
	i18n.inputMethod = {
		type = "fcitx5";
		enable = true;
		fcitx5.addons = with pkgs; [
			fcitx5-mozc
			fcitx5-gtk
		];
	};
}

{ pkgs,  ... }:
# FCitX5 input method for KDE Plasma on Wayland
# For KDE Plasma 5.27+, we should NOT set GTK_IM_MODULE/QT_IM_MODULE globally.
# Instead, use the KCM (Virtual Keyboard) to start fcitx5 and configure via KWin socket.
# Legacy XWayland apps will use XMODIFIERS=@im=fcitx
{
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
	# For KDE Plasma 5.27+ on Wayland with FCitx5:
	# - Do NOT set GTK_IM_MODULE/QT_IM_MODULE/XMODIFIERS globally
	# - Use KWin's virtual keyboard service (installed by i18n.inputMethod)
	# - XWayland apps can still use fcitx via its own detection
}

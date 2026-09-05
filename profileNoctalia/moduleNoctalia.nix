{ inputs, lib, ... }:

{
	services.displayManager.noctalia-greeter.enable = true;
	# services.displayManager.noctalia-greeter.extraArgs = [ ];
	# services.displayManager.noctalia-greeter.cursorTheme.name = "Adwaita";

	programs.umbriel.portalPackage = pkgs.xdg-desktop-portal-umbriel;
	programs.umbriel.enable = true;

	programs.noctalia.enable = true;
	# Enables NetworkManager, Bluetooth, UPower, and a power profile service.
	programs.noctalia.recommendedServices.enable = true;
}

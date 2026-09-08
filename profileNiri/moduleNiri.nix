{ conf, pkgs, lib, userName, ... }:

{
	services.displayManager.dms-greeter.compositor.name = "niri";
	services.displayManager.dms-greeter.enable = true;
	programs.dms-shell.systemd.enable = true;
	programs.dms-shell.enable = true;
	programs.dms-shell.systemd.restartIfChanged = true;

	services.iio-niri.enable = true;
	programs.niri.enable = true;
}

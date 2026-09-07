{ ... }:

{
	services.displayManager.dms-greeter.enable = true;
	programs.dms-shell.systemd.enable = true;
	programs.dms-shell.enable = true;
	programs.dms-shell.systemd.restartIfChanged = true;

	programs.mango.enable = true;
}

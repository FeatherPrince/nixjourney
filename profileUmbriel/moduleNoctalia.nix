{ inputs, lib, ... }:
{
#  imports = [
#    inputs.noctalia.nixosModules.default
#  ];
	services.displayManager.noctalia-greeter.enable = true;

	programs.noctalia = {
		enable = true;

		# Enables NetworkManager, Bluetooth, UPower, and a power profile service.
		recommendedServices.enable = true;
	};

	programs.umbriel.enable = true;
		programs.noctalia = {
		enable = true;

		# Enables NetworkManager, Bluetooth, UPower, and a power profile service.
		recommendedServices.enable = true;
	};
}

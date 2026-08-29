{ inputs, lib, ... }:
{
#  imports = [
#    inputs.noctalia.nixosModules.default
#  ];

  programs.noctalia = {
    enable = true;

    # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
    recommendedServices.enable = true;
  };

  services.displayManager.noctalia-greeter.enable = true;

  programs.umbriel.enable = true;
}

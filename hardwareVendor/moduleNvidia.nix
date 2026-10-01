{ config, pkgs, ... }:

{
  hardware.nvidia = {
    open = false;  # Use proprietary modules unless Turing+
    modesetting.enable = true;  # Required for Wayland
    powerManagement.enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.allowUnfree = true;  # Required for proprietary drivers
}

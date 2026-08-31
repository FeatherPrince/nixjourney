{ config, pkgs, ... }:

{
    hardware.graphics = {
    enable = true;
    enable32Bit = true;
    };

    nixpkgs.config.rocmSupport = true;

    environment.systemPackages = [
      pkgs.rocmPackages.rocm-smi # system management interface
    ];
}

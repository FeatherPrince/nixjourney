{ config, lib, pkgs, gpuVendor ? "auto", ... }:
let
  hasAMD    = gpuVendor == "amd";
  hasNVIDIA = gpuVendor == "nvidia";
  hasIntel  = gpuVendor == "intel";
  anyGPU    = hasAMD || hasNVIDIA || hasIntel;
in
{
  hardware.graphics = lib.mkIf anyGPU {
    enable      = true;
    enable32Bit = true;
  };

  nixpkgs.config = lib.mkIf hasAMD { rocmSupport = true; };

  environment.systemPackages = lib.optionals hasAMD [
    pkgs.rocmPackages.rocm-smi
  ];
}

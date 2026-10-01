{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver  # VA-API for Broadwell+
      intel-compute-runtime  # OpenCL
      vpl-gpu-rt  # oneVPL for 11th gen+
    ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";  # Modern Intel VA-API backend
  };
}

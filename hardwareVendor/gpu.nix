# hardwareVendor/gpu.nix
#
# Detects the GPU vendor(s) of the *build host* by reading the PCI vendor
# IDs exposed under /sys/class/drm, and turns the matching config on.
#
# Requires `--impure` because we read from the live filesystem.
{ config, lib, pkgs, ... }:
let
  drmDir = "/sys/class/drm";

  readVendor = card:
    let p = "${drmDir}/${card}/device/vendor";
    in if builtins.pathExists p
       then lib.removeSuffix "\n" (builtins.readFile p)
       else null;

  cards =
    if builtins.pathExists drmDir
    then builtins.filter (n: builtins.match "card[0-9]+" n != null)
                         (builtins.attrNames (builtins.readDir drmDir))
    else [];

  vendorIds = lib.unique (builtins.filter (x: x != null) (map readVendor cards));

  hasAMD    = builtins.elem "0x1002" vendorIds;
  hasNVIDIA = builtins.elem "0x10de" vendorIds;
  hasIntel  = builtins.elem "0x8086" vendorIds;

  # sanity-check output at eval time
  _ = builtins.trace "GPU vendor IDs detected: ${builtins.toJSON vendorIds}" null;
in
{
  # ---- AMD ----
  hardware.graphics = lib.mkIf (hasAMD || hasIntel) {
    enable     = true;
    enable32Bit = true;
  };

  nixpkgs.config.rocmSupport = lib.mkIf hasAMD true;

  environment.systemPackages = lib.optionals hasAMD [
    pkgs.rocmPackages.rocm-smi
  ];

  # ---- NVIDIA ----
  # Uncomment / fill in when you actually own an NVIDIA box. Guarded by mkIf,
  # so it's inert on AMD/Intel hosts.
  #
  # hardware.nvidia = lib.mkIf hasNVIDIA {
  #   modesetting.enable = true;
  #   powerManagement.enable = true;
  #   open = false;
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };
  # services.xserver.videoDrivers = lib.mkIf hasNVIDIA [ "nvidia" ];

  # ---- Intel ----
  # environment.systemPackages = lib.optionals hasIntel [
  #   pkgs.intel-media-driver
  #   pkgs.vaapiIntel
  # ];
}

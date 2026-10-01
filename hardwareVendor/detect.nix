# hardwareVendor/detect.nix
#
# Inspects /sys/class/drm/card*/device/vendor and returns a list of NixOS
# modules matching the GPUs actually present on the build host.
#
# Requires `--impure` because we read from the live filesystem.
{ lib }:
let
  drmDir = "/sys/class/drm";

  readVendor = card:
    let p = "${drmDir}/${card}/device/vendor";
    in if builtins.pathExists p
       then lib.removeSuffix "\n" (builtins.readFile p)
       else null;

  # Every "cardN" entry (ignores cardN-<connector> render nodes, etc.)
  cards =
    if builtins.pathExists drmDir
    then builtins.filter (n: builtins.match "card[0-9]+" n != null)
                         (builtins.attrNames (builtins.readDir drmDir))
    else [];

  # Unique set of vendor ids present
  vendorIds = lib.unique (builtins.filter (x: x != null) (map readVendor cards));

  vendorModules = {
    "0x1002" = ./moduleAMD.nix;
    "0x10de" = ./moduleNVIDIA.nix;    # create when you have one
    "0x8086" = ./moduleIntel.nix;     # create when you have one
    "0x1af4" = ./moduleVirtio.nix;    # optional
    "0x15ad" = ./moduleVMware.nix;    # optional
    "0x1234" = ./moduleQemu.nix;      # optional (WSL)
  };

  found = builtins.filter (m: m != null)
            (map (id: vendorModules.${id} or null) vendorIds);
in
  found

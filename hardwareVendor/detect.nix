# hardwareVendor/detect.nix
{ lib, ... }:

let
  # Read all PCI devices and collect their vendor IDs.
  # Returns a list of strings like ["0x8086" "0x10de" ...]
  pciDevices = builtins.readDir /sys/bus/pci/devices;

  readVendor = device:
    let
      f = /sys/bus/pci/devices/${device}/vendor;
    in
    if builtins.pathExists f then lib.removeSuffix "\n" (builtins.readFile f) else null;

  vendorIds = lib.filter (v: v != null)
    (lib.map readVendor (builtins.attrNames pciDevices));

  hasVendor = id: lib.elem id vendorIds;

in {
  # Expose this so other modules can read it if needed
  _module.args.gpuVendor =
    if hasVendor "0x10de" then "nvidia"
    else if hasVendor "0x1002" then "amd"
    else if hasVendor "0x8086" then "intel"
    else "unknown";
}

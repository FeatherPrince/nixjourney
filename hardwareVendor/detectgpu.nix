{ lib }:

let
  # Walk PCI devices and collect the vendor ID of everything whose class
  # is 0x03xxxx (display controller: VGA, 3D, XGA, etc.).
  pciEntries = builtins.readDir /sys/bus/pci/devices;

  gpuVendor = dev:
    let
      vendorFile = /sys/bus/pci/devices/${dev}/vendor;
      classFile  = /sys/bus/pci/devices/${dev}/class;
    in
    if !(builtins.pathExists vendorFile && builtins.pathExists classFile)
    then null
    else
      let
        vendor = lib.removeSuffix "\n" (builtins.readFile vendorFile);
        class  = lib.removeSuffix "\n" (builtins.readFile classFile);
      in
      if builtins.match "0x03.*" class != null then vendor else null;

  vendors = builtins.filter (v: v != null)
    (map gpuVendor (builtins.attrNames pciEntries));

  has = id: lib.elem id vendors;
in
  if has "0x10de" then "nvidia"
  else if has "0x1002" then "amd"
  else if has "0x8086" then "intel"
  else "unknown"

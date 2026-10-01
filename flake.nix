{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    userName     = "feather";
    stateVersion = "25.11";
    hostName     = "nix-host";

    lib = nixpkgs.lib;
    gpu = import ./hardwareVendor/detectGpu.nix { inherit lib; };

    gpuModule =
      if gpu == "nvidia" then ./hardwareVendor/moduleNvidia.nix
      else if gpu == "amd"    then ./hardwareVendor/moduleAMD.nix
      else if gpu == "intel"  then ./hardwareVendor/moduleIntel.nix
      else null;


    # Build a NixOS system. Everything that is shared lives here; callers
    # only supply the bits that actually differ between hosts.
    mkHost = { extraModules ? [], extraHomeModules ? [] }:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit stateVersion userName hostName; };
        modules = [
          ./configuration.nix
          ./hardwareVendor/moduleAMD.nix
        ]
        ++ extraModules
        ++ [
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs       = true;
              useUserPackages     = true;
              backupFileExtension = "backup";
              extraSpecialArgs    = { inherit userName gpu; };
              users.${userName} = {
                imports = [ ./home.nix ] ++ extraHomeModules;
              };
            };
          }
        ];
      };
  in
  {
    nixosConfigurations = {
      wsl      = mkHost { };
      hyprland = mkHost { extraModules = [ ./Profiles/profileHyprland/moduleHyprland.nix ]; };
      plasma   = mkHost { extraModules = [ ./Profiles/profilePlasma/modulePlasma.nix ]; };
      noctalia = mkHost { extraModules = [ ./Profiles/profileNoctalia/moduleNoctalia.nix ]; };
      mangowm  = mkHost { extraModules = [ ./Profiles/profileMangowm/moduleMangowm.nix ]; };
      niri     = mkHost { extraModules = [ ./Profiles/profileNiri/moduleNiri.nix ]; };

      gnome = mkHost {
        extraModules     = [ ./Profiles/profileGnome/moduleGnome.nix ];
        extraHomeModules = [ ./Profiles/profileGnome/homeGnome.nix ];
      };
    };
  };
}

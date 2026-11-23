{
  description = "A very basic flake";
  # before creating a new configuration run 'nix flake check --impure' in the flake directory
  inputs = {
    nixpkgs      = { url = "github:nixos/nixpkgs?ref=nixos-unstable"; };
    sops-nix     = { url = "github:Mic92/sops-nix";                     inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = "github:nix-community/home-manager";         inputs.nixpkgs.follows = "nixpkgs"; };
    nixvim       = { url = "github:nix-community/nixvim";               inputs.nixpkgs.follows = "nixpkgs"; };
    bootvine     = { url = "git+https://codeberg.org/wvhulle/bootvine"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, bootvine, ... }:
  let
    hostName     = "nest";
    userName     = "feather";
    stateVersion = "26.05";

    # Build a NixOS system. Everything that is shared lives here; callers
    # only supply the bits that actually differ between hosts.
    mkHost = { stateVersion ? [], homeStateVersion ? [], hardwareModule ? [], systemModules ? [], homeModules ? [] }:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit stateVersion userName hostName; };
        modules = [
          bootvine.nixosModules.default
          sops-nix.nixosModules.sops
          { nixpkgs.overlays = [ ]; }
        ]
        ++ systemModules
        ++ [
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs       = true;
              useUserPackages     = true;
              backupFileExtension = "backup";
              extraSpecialArgs    = { inherit userName; };
              users.${userName} = {
                imports = homeModules;
              };
            };
          }
        ];
      };
  in
  {
    nixosConfigurations = {
      # wsl      = mkHost { };
      # host1    = mkHost {
      #   hardwareModule = [];
      #   systemModules  = [];
      #   homeModules    = [];
      # };
      # hyprland = mkHost { systemModules = [ ./Profiles/profileHyprland/moduleHyprland.nix ]; };
      canary = mkHost { systemModules = [ ./modulesHosts/Host1/moduleHost1.nix ]; homeModules = [ ./modulesHosts/Host1/homeHost1.nix ]; };
      # noctalia = mkHost { systemModules = [ ./Profiles/profileNoctalia/moduleNoctalia.nix ]; };
      # mangowm  = mkHost { systemModules = [ ./Profiles/profileMangowm/moduleMangowm.nix ]; };
      # niri     = mkHost { systemModules = [ ./Profiles/profileNiri/moduleNiri.nix ]; };

      # gnome = mkHost {
      #   systemModules     = [ ./Profiles/profileGnome/moduleGnome.nix ];
      #   homeModules = [ ./Profiles/profileGnome/homeGnome.nix ];
      # };
    };
  };
}


# TODO
# set userName, hostName, homeStateVersion and systemStateVersion from the flake
# hostName should be the same as the profile name

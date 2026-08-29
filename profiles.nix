{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {

      # Configuration 1: Hyprland
      Hyprland = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # ./hosts/laptop/configuration.nix
        ];
      };

      # Configuration 2: Noctalia
      Noctalia = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # ./hosts/server/configuration.nix
        ];
      };

      # Configuration 3: Headless
      Headless = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # ./hosts/desktop/configuration.nix
        ];
      };
    };
  };
}

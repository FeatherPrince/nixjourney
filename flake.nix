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
    # 1. Define the variable in a 'let' block
    userName = "feather"; 
  in
  {
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
      specialArgs = { 
        stateVersion = "25.11"; 
        userName = "feather";
        hostName = "nix-host";
      };
			modules = [
				./configuration.nix
				home-manager.nixosModules.home-manager {
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						backupFileExtension = "backup";
            extraSpecialArgs = { inherit userName; };
						users.${userName} = import ./home.nix;
					};
				}
			];
		};
	};
}

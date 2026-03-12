{
  description = "A very basic flake";

	inputs = {
	nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		home-manager-unstable = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
		nixosConfigurations.nixos-host = nixpkgs.lib.nixeosSystem {
			system = "x86_64-linux";
			modules = [
				./configuration.nix
				home-manager.nixosModules.home.manager {
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.feather = import ./home.nix;
						backupFileExtension = "backup";
					};
				}
			];
		};
	};
}

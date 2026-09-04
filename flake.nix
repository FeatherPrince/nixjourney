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
# ```let in``` lets user define variables inside of the flake, while specialArgs allow other files to use it
	let
		userName = "feather";
		stateVersion = "25.11";
		hostName = "nix-host";
	in
	{
	nixosConfigurations = {
		nixos = nixpkgs.lib.nixosSystem {
		};
		hyprland = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = {
				stateVersion = stateVersion;
				userName = userName;
				hostName = hostName;
			};
			modules = [
				./profileHyprland/moduleHyprland.nix
				./configuration.nix
				./hardwareVendor/moduleAMD.nix
				home-manager.nixosModules.home-manager {
				home-manager = {
				useGlobalPkgs = true;
				useUserPackages = true;
				backupFileExtension = "backup";
				extraSpecialArgs = { inherit userName; };
				users.${userName} = import ./home.nix;
				};}
 			];
		};
		plasma = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = {
				stateVersion = stateVersion;
				userName = userName;
				hostName = hostName;
			};
			modules = [
				./profilePlasma/modulePlasma.nix
				./configuration.nix
				./hardwareVendor/moduleAMD.nix
				home-manager.nixosModules.home-manager {
				home-manager = {
				useGlobalPkgs = true;
				useUserPackages = true;
				backupFileExtension = "backup";
				extraSpecialArgs = { inherit userName; };
				users.${userName} = import ./home.nix;
				};}
			];
		};
		gnome = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = {
				stateVersion = stateVersion;
				userName = userName;
				hostName = hostName;
			};
			modules = [
				./profileGnome/moduleGnome.nix
				./configuration.nix
				./hardwareVendor/moduleAMD.nix
				home-manager.nixosModules.home-manager {
				home-manager = {
				useGlobalPkgs = true;
				useUserPackages = true;
				backupFileExtension = "backup";
				extraSpecialArgs = { inherit userName; };
				users.${userName} = {
					imports = [
						./home.nix
						./profileGnome/homeGnome.nix
					];
					};
					};
					}
				];
			};
		};
	};
}

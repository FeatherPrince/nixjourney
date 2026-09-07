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
							users.${userName} = {
								imports = [
									./home.nix
								];
							};
						};
					}
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
							users.${userName} = {
								imports = [
									./home.nix
								];
							};
						};
					}
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
			noctalia = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {
					stateVersion = stateVersion;
					userName = userName;
					hostName = hostName;
				};
				modules = [
					./profileNoctalia/moduleNoctalia.nix
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
								];
							};
						};
					}
				];
			};
			mangowm = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {
					stateVersion = stateVersion;
					userName = userName;
					hostName = hostName;
				};
				modules = [
					./profileMangowm/moduleMangowm.nix
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
								];
							};
						};
					}
				];
			};
			niri = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {
					stateVersion = stateVersion;
					userName = userName;
					hostName = hostName;
				};
				modules = [
					./profileNiri/moduleNiri.nix
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
								];
							};
						};
					}
				];
			};
		};
	};
}

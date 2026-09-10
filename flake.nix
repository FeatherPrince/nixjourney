{
	description = "A very basic flake";

	inputs = {
	nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	# NixOS-WSL for WSL2 configuration
	# nixos-wsl = {
	# 	url = "github:nix-community/NixOS-WSL?rev=807c50464eb9d84e8dfcc3a0b623b12a10f5f380";
	# 	inputs.nixpkgs.follows = "nixpkgs";
	# };
	# Additional useful Nixpkgs inputs for WSL optimization
	nixos-hardware.url = "github:nixos/nixos-hardware";

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
			wsl = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {
					stateVersion = stateVersion;
					userName = userName;
					hostName = hostName;
				};
				modules = [
					# ./profileHyprland/moduleHyprland.nix
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
			hyprland = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {
					stateVersion = stateVersion;
					userName = userName;
					hostName = hostName;
				};
				modules = [
					./Profiles/profileHyprland/moduleHyprland.nix
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
					./Profiles/rofilePlasma/modulePlasma.nix
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
					./Profiles/rofileGnome/moduleGnome.nix
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
									./Profiles/rofileGnome/homeGnome.nix
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
					./Profiles/rofileNoctalia/moduleNoctalia.nix
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
					./Profiles/rofileMangowm/moduleMangowm.nix
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
					./Profiles/rofileNiri/moduleNiri.nix
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

# overlays/llama-cpp.nix
llama-cpp-latest: final: prev: {
	llama-cpp-vulkan = prev.llama-cpp-vulkan.overrideAttrs (old: {
		src = llama-cpp-latest;
		version = "git-" + builtins.substring 0 8 llama-cpp-latest.rev;
	});
}

{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

		# The input stays here
		llama-cpp-latest = {
			url = "github:ggerganov/llama.cpp";
			flake = false;
		};
	};

	outputs = { self, nixpkgs, llama-cpp-latest, ... }: {
		nixosConfigurations."your-hostname" = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./configuration.nix

				# Import the overlay and pass the input to it
				({ pkgs, ... }: {
					nixpkgs.overlays = [
						(import ./overlays/llama-cpp.nix llama-cpp-latest)
					];
				})
			];
		};
	};
}

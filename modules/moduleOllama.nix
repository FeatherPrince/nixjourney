{ config, lib, pkgs, ... }:

{
	# services.ollama = {
	# 	enable = true;
	# 	# loadModels = [
	# 	# 	"qwen3.8:27b"			#
	# 	# 	"deepseek-r1:14b"		#
	# 	# 	"deepseek-coder:1.3b"	# 776 MB
	# 	# 	"deepseek-coder:6.7b"	#
	# 	# 	"deepseek-coder-v2:16b"	#
	# 	# ];
	# 	# OPTIONAL: Enable GPU acceleration (Uncomment the one you need)
	# 	package = pkgs.ollama-vulkan;
	# 	# package = pkgs.ollama;
	# 	# package = pkgs.ollama-cpu;
	# 	# package = pkgs.ollama-rocm;
	# 	# package = pkgs.ollama-cuda;

	# 	# OPTIONAL: Set environment variables (e.g., to allow external network access)
	# 	# environmentVariables = {
	# 	# 	# OLLAMA_HOST = "0.0.0.0"; # Uncomment to allow access from other devices on your network
	# 	# };

	# 	# override for when a machine has an integrated AND a discrete GPU so it forces the discrete
	# 	# environment = {
	# 	#   GGML_VULKAN_DEVICE = "1";
	# 	# };
	# 	users.users.ollama.extraGroups = [ "video" "render" ];
	# };

	# user service inherits user variables which makes it much easier to manage, it also starts after login
	services.ollama.enable = false;
	systemd.user.services.ollama = {
		description = "Ollama (Vulkan User Service)";
		after = [ "network.target" ];
		wantedBy = [ "default.target" ]; # This ensures it starts when you log in

		serviceConfig = {
			ExecStart = "${pkgs.ollama-vulkan}/bin/ollama serve";
			Restart = "always";
			RestartSec = 3;

			# Optional but recommended: Limit memory/CPU if it goes rogue
			# MemoryMax = "14G";
		};
	};
	environment.systemPackages = with pkgs; [
		vulkan-tools
		ollama # For the CLI tool
	];
}

{ config, lib, pkgs, ... }:

{
	# a system wide service that starts before any user has logged in which prevents some race conditions from occuring, like when an app is launched before a user service had time to launch
	# services.nextjs-ollama-llm-ui.enable = true;
	users.users.ollama.extraGroups = [ "video" "render" ]; # this is important, this gives ollama relevant permissions to use the gpu
	services.ollama = {
		enable = true;
		# loadModels = [
		# 	"qwen3.8:27b"			#
		# 	"deepseek-r1:14b"		#
		# 	"deepseek-coder:1.3b"	# 776 MB
		# 	"deepseek-coder:6.7b"	#
		# 	"deepseek-coder-v2:16b"	#
		# ];

		# OPTIONAL: Enable GPU acceleration (Uncomment the one you need)
		# package = pkgs.ollama;
		# package = pkgs.ollama-cpu;
		package = pkgs.ollama-vulkan; # seems to just work fine
		# package = pkgs.ollama-rocm;
		# package = pkgs.ollama-cuda;

		user = "ollama";
		group = config.services.ollama.user;
		environmentVariables = {
			# GGML_VULKAN_DEVICE = "0"; # this needs to be set to the discrete gpu | vulkaninfo summary
			VulkanDeviceSelection = "auto"; # that's it I guess, that's the todo done . . .
			# HSA_OVERRIDE_GFX_VERSION = "12.0.0"; # rocm version override specifically for the 9060 xt 16GB | rocminfo | grep -i "Name:"
		};
	};

	systemd.services.ollama = {
		after = [ "systemd-udevd.service" "multi-user.target" ];
		wants = [ "systemd-udevd.service" ];

		serviceConfig = {
			# The AMDGPU driver takes a few seconds to load firmware at boot.
			# This 10-second delay guarantees the GPU is fully initialized
			# before Ollama tries to probe it.
			ExecStartPre = "${pkgs.coreutils}/bin/sleep 10";
		};
	};
	# user service inherits user variables which makes it much easier to manage, it also starts after login
	# services.ollama.enable = false;
	# systemd.user.services.ollama = {
	# 	description = "Ollama (Vulkan User Service)";
	# 	after = [ "network.target" ];
	# 	wantedBy = [ "default.target" ]; # This ensures it starts when you log in

	# 	serviceConfig = {
	# 		ExecStart = "${pkgs.ollama-vulkan}/bin/ollama serve";
	# 		Restart = "always";
	# 		RestartSec = 3;

	# 		# Optional but recommended: Limit memory/CPU if it goes rogue
	# 		# MemoryMax = "14G";
	# 	};
	# };
	# environment.systemPackages = with pkgs; [
	# 	vulkan-tools
	# 	ollama # For the CLI tool
	# ];
}

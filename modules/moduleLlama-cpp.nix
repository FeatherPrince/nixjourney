{ config, lib, pkgs, ... }:

{
	# a system wide service that starts before any user has logged in which prevents some race conditions from occuring, like when an app is launched before a user service had time to launch
	# services.nextjs-llama-cpp-llm-ui.enable = true;
	users.users.llama-cpp.extraGroups = [ "video" "render" ]; # this is important, this gives llama-cpp relevant permissions to use the gpu
	environment.systemPackages = llama-cpp;
	services.llama-cpp = {
		# settings.host = "127.0.0.1";
		# settings.port = 8000;
		openFirewall = true;
		enable = true;
		loadModels = [
			# "qwen3.8:27b"			#
			# "deepseek-r1:14b"		#
			# "deepseek-coder:1.3b"	# 776 MB
			# "deepseek-coder:6.7b"	#
			# "deepseek-coder-v2:16b"	#
			# llama-cpp run hf.co/prism-ml/Ternary-Bonsai-2-27B-gguf:Q2_0
		];

		# OPTIONAL: Enable GPU acceleration (Uncomment the one you need)
		#
		# package = pkgs.llama-cpp;
		# package = pkgs.llama-cpp-cpu;
		package = pkgs.llama-cpp-vulkan; # seems to just work fine
		# package = pkgs.llama-cpp-rocm;
		# package = pkgs.llama-cpp-cuda;

		user = "llama-cpp";
		group = config.services.llama-cpp.user;
		environmentVariables = {
			# GGML_VULKAN_DEVICE = "0"; # this needs to be set to the discrete gpu | vulkaninfo summary
			VulkanDeviceSelection = "auto"; # that's it I guess, that's the todo done . . .
			# HSA_OVERRIDE_GFX_VERSION = "12.0.0"; # rocm version override specifically for the 9060 xt 16GB | rocminfo | grep -i "Name:"
		};
	};

	systemd.services.llama-cpp = {
		after = [ "systemd-udevd.service" "multi-user.target" ];
		wants = [ "systemd-udevd.service" ];

		serviceConfig = {
			# The AMDGPU driver takes a few seconds to load firmware at boot.
			# This 10-second delay guarantees the GPU is fully initialized
			# before llama-cpp tries to probe it.
			ExecStartPre = "${pkgs.coreutils}/bin/sleep 10";
		};
	};
}

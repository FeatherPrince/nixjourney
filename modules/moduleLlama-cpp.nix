{ config, lib, pkgs, ... }:

{
	# a system wide service that starts before any user has logged in which prevents some race conditions from occuring, like when an app is launched before a user service had time to launch
	# services.nextjs-llama-cpp-llm-ui.enable = true;
	# users.users.llama-cpp.extraGroups = [ "video" "render" ]; # this is important, this gives llama-cpp relevant permissions to use the gpu
	environment.systemPackages = [ pkgs.llama-cpp-rocm ];
	services.llama-cpp = {
		# settings.host = "127.0.0.1";
		# settings.port = 8080;
		openFirewall = true;
		enable = true;

		# OPTIONAL: Enable GPU acceleration (Uncomment the one you need)
		#
		# package = pkgs.llama-cpp;
		# package = pkgs.llama-cpp-cpu;
		# package = pkgs.llama-cpp-vulkan; # seems to just work fine
		package = pkgs.llama-cpp-rocm;
		# package = pkgs.llama-cpp-cuda;

		# user = "llama-cpp";
		# group = config.services.llama-cpp.user;
		settings = {
      # host = "0.0.0.0";          # Allow access from localhost and your local network
      # port = 8080;
      model = "/var/lib/llama-cpp/models/Ternary-Bonsai-2-27B-PQ2_0.gguf";
      "n-gpu-layers" = 999;      # Offload all layers to your AMD GPU (equivalent to -ngl 999)
      "ctx-size" = 32768;        # Context size (lower → freed VRAM + faster tokens/s)
      "n-threads" = 16;          # all logical threads on the 9700X
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
			# Do NOT add a custom ExecStart here. services.llama-cpp already builds
			# one from `package` + `settings`. A custom one merges into *multiple*
			# ExecStart= lines and the module-generated (foreground) one runs first,
			# blocking the rest — so it never takes effect.
		};
	};
}

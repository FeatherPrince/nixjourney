{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		python3
		nodejs
		python314Packages.matplotlib
		cmake
		cmakeCurses
		cmakeWithGui
	];
}

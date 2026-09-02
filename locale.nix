{ pkgs, ... }:


{
	time.timeZone = "Europe/Warsaw";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";
	i18n.extraLocales = [
		"all"
		# "en_US.UTF-8/UTF-8"
		# "fr_FR.UTF-8/UTF-8"
		# "de_DE.UTF-8/UTF-8"
		# "es_ES.UTF-8/UTF-8"
		# "pl_PL.UTF-8/UTF-8"
	];
	i18n.imperativeLocale = true;

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "pl_PL.UTF-8";
		LC_IDENTIFICATION = "pl_PL.UTF-8";
		LC_MEASUREMENT = "pl_PL.UTF-8";
		LC_MONETARY = "pl_PL.UTF-8";
		LC_NAME = "pl_PL.UTF-8";
		LC_NUMERIC = "pl_PL.UTF-8";
		LC_PAPER = "pl_PL.UTF-8";
		LC_TELEPHONE = "pl_PL.UTF-8";
		LC_TIME = "pl_PL.UTF-8";
	};
	console.keyMap = "pl2";

	environment = {
		systemPackages = [ pkgs.stdenv.cc.libc.out ]; # this derivation contains the locales
		pathsToLink = [ "/share/i18n" ];
	};
}

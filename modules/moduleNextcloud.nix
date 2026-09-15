{ ... }:

{
	environment.etc."nextcloud-admin-pass".text = "PWD";
	services.nextcloud = {
		enable = true;
		hostName = "localhost";
		config.adminpassFile = "/etc/nextcloud-admin-pass";
		config.dbtype = "sqlite";
		settings = {
			# Some sane defaults required to satisfy Nextcloud configuration check
			maintenance_window_start = 1;
			default_phone_region = "DE";
			log_type = "systemd";
			serverid = 0;
		};
	};
}

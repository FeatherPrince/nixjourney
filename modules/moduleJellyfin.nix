{ pkgs, ... }:


	let
		domain = "featherlabs.fyi";
		tunnelID = "a525368b-2937-4b9c-be2b-57e509148a92";
	in
{
	# environment.etc."nextcloud-admin-pass".text = "PWD";
	# services.nextcloud = {
	# 	appstoreEnable = true;
	# 	enable = true;
	# 	# extraAppsEnable = true;
	# 	# package = "";
	# 	hostName = "localhost";
	# 	config.adminpassFile = "/etc/nextcloud-admin-pass";
	# 	config.dbtype = "sqlite";
	# 	settings = {
	# 		# Some sane defaults required to satisfy Nextcloud configuration check
	# 		maintenance_window_start = 1;
	# 		default_phone_region = "DE";
	# 		log_type = "systemd";
	# 		serverid = 0;
	# 	};
	# };







	users.groups.media = {};
	# users.users.seerr.extraGroups = [ "media" ];

	systemd.tmpfiles.rules = [
	    "d /srv/media 2775 root media -"
	    "d /srv/media/movies 2775 root media -"
	    "d /srv/media/shows 2775 root media -"
	    "d /srv/media/music 2775 root media -"
	    "d /srv/media/downloads 2775 root media -"
	    "d /srv/media/downloads/incomplete 2775 root media -"
	    "d /srv/media/downloads/watch 2775 root media -"
	    "d /srv/media/downloads/radarr 2775 root media -"
	    "d /srv/media/downloads/tv-sonarr 2775 root media -"
		"d /var/lib/dashy 0775 dashy root -"
		"d /var/lib/cloudflared/ 0775 cloudflared root -"
	    "d /srv/media/immich 2775 root media -"
	    "d /srv/media/immich/upload 2775 immich media -"
	    "d /srv/media/immich/encoded-video 2775 immich media -"
	    "d /srv/media/immich/thumbs 2775 immich media -"
	    "d /srv/media/immich/backups 2775 immich media -"
	    "d /srv/media/immich/library 2775 immich media -"
	    "d /srv/media/immich/profile 2775 immich media -"
	];

	# services.bazarr.enable
	# readarr
	# recyclarr
	# tdarr
	# yarr
	# lidarr
	# whisparr

	environment.systemPackages = with pkgs; [
		# nginx
		cloudflared
	];
	# services.nginx.enable = true;

	users.users.immich.extraGroups = [ "media" "video" "render" ];
	services.immich = {
		enable = true;
		openFirewall = true;
		mediaLocation = "/srv/media/immich";
		# host = "127.0.0.1";
		port = 2283;
	};

	# users.users.prowlarr.extraGroups = [ "media" ];
	services.prowlarr = {
		enable = true;
		openFirewall = true;
	};

	# users.users.seerr.extraGroups = [ "media" ];
	services.seerr = {
		enable = true;
		openFirewall = true;
	};

	users.users.whisparr.extraGroups = [ "media" ];
	services.whisparr = {
		enable = true;
		openFirewall = true;
	};

	users.users.sonarr.extraGroups = [ "media" ];
	services.sonarr = {
		enable = true;
		openFirewall = true;
	};

	users.users.radarr.extraGroups = [ "media" ];
	services.radarr = {
		enable = true;
		openFirewall = true;
	};

	# users.users.jellyfin.isSystemUser = true;
	users.users.jellyfin.extraGroups = [ "media" "video" "render" ];
	services.jellyfin = {
		openFirewall = true;
		enable = true;
		# hardwareAcceleration.enable = true;
	};

	users.users.transmission.extraGroups = [ "media" ];
	services.transmission = {
		enable = true;
		openFirewall = true;
		settings = {
			download-dir = "/srv/media/downloads";  # Shared download location
			incomplete-dir = "/srv/media/downloads/incomplete";
			watch-dir = "/srv/media/downloads/watch";
			watch-dir-enabled = true;
			download-dir-free-space = 10;
		};
		# rpc-whitelist = "127.0.0.1,::1,192.168.*.*"; # this would allow connections other than from the host machine
	};

	# 1. THE LOCAL PHONEBOOK (Hosts File)
	# This tells your machine: "When I type jellyfin.feather, go to 127.0.0.1 (myself)"
	networking.extraHosts =
	''
		127.0.0.1 ${domain}
		127.0.0.1 immich.${domain}
		127.0.0.1 nextcloud.${domain}
		127.0.0.1 whisparr.${domain}
		127.0.0.1 jellyfin.${domain}
		127.0.0.1 prowlarr.${domain}
		127.0.0.1 radarr.${domain}
		127.0.0.1 sonarr.${domain}
		127.0.0.1 seerr.${domain}
		127.0.0.1 transmission.${domain}
		127.0.0.1 dashboard.${domain}
	'';


	# 2. THE RECEPTIONIST (Reverse Proxy)
	# This listens on port 80 and routes the traffic to the correct local ports.
	# We use Caddy because it's the easiest to configure.
	services.caddy = {
		enable = true;

		virtualHosts = {
			# --- CLOUDFLARE TRAFFIC (HTTP) ---
			"http://${domain}" = {
				extraConfig = "reverse_proxy 127.0.0.1:3000";
			};
			"http://dashboard.${domain}" = {
				extraConfig = "reverse_proxy 127.0.0.1:3000";
			};
			"http://jellyfin.${domain}" = {
				extraConfig = "reverse_proxy 127.0.0.1:8096";
			};
			"http://radarr.${domain}" = {
				extraConfig = "reverse_proxy 127.0.0.1:7878";
			};
			"http://sonarr.${domain}" = {
				extraConfig = "reverse_proxy 127.0.0.1:8989";
			};
			"http://seerr.${domain}" = {
				extraConfig = "reverse_proxy 127.0.0.1:5055";
			};
			"http://transmission.${domain}" = {
				extraConfig = ''
					reverse_proxy 127.0.0.1:9091 {
						header_up Host {host}
						header_up Origin {scheme}://{host}
					}
				'';
			};
			"http://immich.${domain}" = {
				extraConfig = ''
					reverse_proxy [::1]:2283 {
						header_up Host {host}
					}
				'';
			};

			# --- LOCAL TRAFFIC (HTTPS with self-signed cert) ---
			"https://${domain}" = {
				extraConfig = "tls internal\nreverse_proxy 127.0.0.1:3000";
			};
			"https://dashboard.${domain}" = {
				extraConfig = "tls internal\nreverse_proxy 127.0.0.1:3000";
			};
			"https://jellyfin.${domain}" = {
				extraConfig = "tls internal\nreverse_proxy 127.0.0.1:8096";
			};
			"https://radarr.${domain}" = {
				extraConfig = "tls internal\nreverse_proxy 127.0.0.1:7878";
			};
			"https://sonarr.${domain}" = {
				extraConfig = "tls internal\nreverse_proxy 127.0.0.1:8989";
			};
			"https://seerr.${domain}" = {
				extraConfig = "tls internal\nreverse_proxy 127.0.0.1:5055";
			};
			"https://transmission.${domain}" = {
				extraConfig = ''
					tls internal
					reverse_proxy 127.0.0.1:9091 {
						header_up Host {host}
						header_up Origin {scheme}://{host}
					}
				'';
			};
			"https://immich.${domain}" = {
				extraConfig = ''
					tls internal
					reverse_proxy [::1]:2283 {
						header_up Host {host}
					}
				'';
			};
		};
	};


	# setup steps for cloudflared
	# sudo cloudflared tunnel login # this will spawn a file in /root/.cloudflared/cert.pem after you have this file you can use
	# sudo cloudflared tunnel create mytunnel # mytunnel is just a tunnel name, it can be whatever you want # move this file to wherever services.cloudflared.tunnels.credentialsFile is pointing
	# sudo cloudflared tunnel route dns mytunnel "*.featherlabs.fyi" # to add a dns entry pointing to the tunnel
	services.cloudflared = {
		enable = true;
		tunnels."${tunnelID}" = {
			credentialsFile = "/var/lib/cloudflared/creds.json";
			default = "http_status:404";
			ingress = {
				"featherlabs.fyi" = "http://localhost:80";
				"*.featherlabs.fyi" = "http://localhost:80";
			};
		};
	};
	# 3. FIREWALL
	# Allow traffic on port 80 (HTTP) so the reverse proxy can work.
	networking.firewall.allowedTCPPorts = [ 80 443];
	# services.homer = {
	# 	enable = true;
	# 	virtualHost.caddy.enable = true;
	# };



	services.homepage-dashboard = {
	enable = true;
		listenPort = 3000;
	allowedHosts = "dashboard.${domain},dashboard,localhost,127.0.0.1";
		# This automatically creates the menu and links for your services
		services = [
			{
				"Media" = [
					{ "Immich" = { href = "http://immich.${domain}"; icon = "immich.png"; description = "Browse your gallery"; }; }
					{ "Jellyfin" = { href = "http://jellyfin.${domain}"; icon = "jellyfin.png"; description = "Stream your media"; }; }
					{ "Seerr" = { href = "http://seerr.${domain}"; icon = "seerr.png"; description = "Request movies & shows"; }; }
				];
			}
			{
				"Automation" = [
					{ "Radarr" = { href = "http://radarr.${domain}"; icon = "radarr.png"; }; }
					{ "Sonarr" = { href = "http://sonarr.${domain}"; icon = "sonarr.png"; }; }
					{ "Prowlarr" = { href = "http://prowlarr.${domain}"; icon = "prowlarr.png"; }; }
				];
			}
			{
				"Downloads" = [
					{ "Transmission" = { href = "https://transmission.${domain}"; icon = "transmission.png"; }; }
				];
			}
		];
	};


	# solving connection types:
	# from host: caddy - reverse dns
	# from LAN: static/local DNS from the router, redirect "*.featherlabs.fyi" to the IP of the server OR configure the server as a DNS server and point your router to it
	# from outside of the LAN: cloudflared tunnel
}

{ config, lib, pkgs, userName, ... }:

let
  flakeRoot = ../.;  # only if the module is 2 levels deep
  domain  = "featherlabs.fyi";
  authUrl = "https://auth.${domain}";
  tunnelID = "a525368b-2937-4b9c-be2b-57e509148a92";

  certFile    = "/var/lib/acme/${domain}/fullchain.pem";
  certKeyFile = "/var/lib/acme/${domain}/key.pem";

  # Collapse the ~12 identical reverse-proxy vhosts
  mkProxy = { port, extra ? "" }:
    { addSSL            = true;
      sslCertificate    = certFile;
      sslCertificateKey = certKeyFile;
      locations."/" = {
        proxyPass       = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true;
      } // lib.optionalAttrs (extra != "") { extraConfig = extra; };
    };
in
{
  # ── Secrets ────────────────────────────────────────────────────────
  sops = {
    defaultSopsFile = flakeRoot + "/secrets/featherlabs.yaml";
    age.keyFile     = "/var/lib/sops-nix/key.txt";
    secrets = {
      kanidm-admin-password          = { owner = "kanidm"; mode = "0400"; };
      kanidm-idm-admin-password      = { owner = "kanidm"; mode = "0400"; };
      gitea-db-password              = { owner = "gitea";  mode = "0400"; };
      gitea-oidc-secret              = { owner = "kanidm"; group = "kanidm"; mode = "0440"; };
      immich-oidc-secret             = { owner = "kanidm"; group = "kanidm"; mode = "0440"; };
      nextcloud-oidc-secret          = { owner = "kanidm"; group = "kanidm"; mode = "0440"; };
      seerr-oidc-secret              = { owner = "kanidm"; group = "kanidm"; mode = "0440"; };
      nextcloud-admin-password       = { owner = "nextcloud"; mode = "0400"; };
      nextcloud-db-password          = { owner = "nextcloud"; mode = "0400"; };
      homarr-oidc-secret             = { owner = "kanidm"; group = "kanidm"; mode = "0440"; };
      homarr-secret-encryption-key   = { owner = "root";   mode = "0400"; };
      # add immich-oidc-secret / nextcloud-oidc-secret if you wire OIDC there
    };
  };

  # ── ACME / TLS ─────────────────────────────────────────────────────
  security.acme = {
    acceptTerms    = true;
    defaults.email = "bqcd4ktz@proton.me";
    certs.${domain} = {
      domain           = domain;
      extraDomainNames = [ "*.${domain}" ];
      dnsProvider      = "cloudflare";
      environmentFile  = "/var/lib/acme/cloudflare.env";
      dnsResolver      = "1.1.1.1:53";
      group            = "nginx";
      reloadServices   = [ "nginx.service" "kanidmd.service" ];
    };
  };

  # ── Users / groups / dirs ──────────────────────────────────────────
  users.groups.media = {};
  # kanidmd needs to read the acme cert; add it to nginx group (cert group)
  users.users.kanidm.extraGroups = [ "nginx" ];

  users.users.immich.extraGroups     = [ "media" "video" "render" ];
  users.users.jellyfin.extraGroups   = [ "media" "video" "render" ];
  users.users.sonarr.extraGroups     = [ "media" ];
  users.users.radarr.extraGroups     = [ "media" ];
  users.users.whisparr.extraGroups   = [ "media" ];
  users.users.transmission.extraGroups = [ "media" ];

  systemd.tmpfiles.rules = [
    "d /srv/media                      2775 root    media -"
    "d /srv/media/movies               2775 root    media -"
    "d /srv/media/shows                2775 root    media -"
    "d /srv/media/music                2775 root    media -"
    "d /srv/media/downloads            2775 root    media -"
    "d /srv/media/downloads/incomplete 2775 root    media -"
    "d /srv/media/downloads/watch      2775 root    media -"
    "d /srv/media/downloads/radarr     2775 root    media -"
    "d /srv/media/downloads/tv-sonarr  2775 root    media -"
    "d /srv/media/immich               2775 root    media -"
    "d /srv/media/immich/upload        2775 immich  media -"
    "d /srv/media/immich/encoded-video 2775 immich  media -"
    "d /srv/media/immich/thumbs        2775 immich  media -"
    "d /srv/media/immich/backups       2775 immich  media -"
    "d /srv/media/immich/library       2775 immich  media -"
    "d /srv/media/immich/profile       2775 immich  media -"
    "d /var/lib/dashy                  0775 dashy   root  -"
    "d /var/lib/cloudflared            0775 cloudflared root -"
    # "d /var/lib/nextcloud              0750 nextcloud nextcloud -"
    # "d /var/lib/nextcloud/config       0750 nextcloud nextcloud -"
  ];

  environment.systemPackages = with pkgs; [ dig cloudflared nginx openssl gitea immich sops kanidmWithSecretProvisioning_1_11 ];

  # ── Postgres ───────────────────────────────────────────────────────
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" "gitea" ];
    ensureUsers = [
      { name = "nextcloud"; ensureDBOwnership = true; }
      { name = "gitea";     ensureDBOwnership = true; }
    ];
    authentication = lib.mkForce ''
      local all all              peer
      host  all all 127.0.0.1/32 trust
      host  all all ::1/128      trust
    '';
  };

  systemd.services.kanidm = {
    after = [ "sops-install-secrets.service" ];
    wants = [ "sops-install-secrets.service" ];
    # after = [ "nginx.service" ];
    # wants = [ "nginx.service" ];
  };

  systemd.services.nextcloud-setup = {
    after    = [ "sops-install-secrets.service" "postgresql.service" ];
    wants    = [ "sops-install-secrets.service" ];
    requires = [ "postgresql.service" ];
  };

  systemd.services.nextcloud-update-db = {
    after    = [ "sops-install-secrets.service" "postgresql.service" ];
    wants    = [ "sops-install-secrets.service" ];
    requires = [ "postgresql.service" ];
  };

  # ── Gitea ──────────────────────────────────────────────────────────
  services.gitea = {
    enable   = true;
    appName  = "Featherlabs Git";
    database = {
      type         = "postgres";
      passwordFile = config.sops.secrets.gitea-db-password.path;
    };

    settings = {
      server = {
        # DOMAIN                   = "git.${domain}";
        ROOT_URL                 = "https://git.${domain}/";
        HTTP_ADDR                = "127.0.0.1";
        HTTP_PORT                = 3001;
        ENABLE_FORWARDED_HEADERS = true;
      };
      service = {
      DISABLE_REGISTRATION                  = false;
      ALLOW_ONLY_EXTERNAL_REGISTRATION      = true;
      };
      oauth2_client = {
        ENABLE_AUTO_REGISTRATION            = true;
        # ACCOUNT_LINKING                     = "auto";
        KANIDM_PROVIDER                     = "openidConnect";
        KANIDM_CLIENT_ID                    = "gitea";
        KANIDM_CLIENT_SECRET                = "placeholder-overridden-by-env";
        KANIDM_OPENID_CONNECT_DISCOVERY_URL = "${authUrl}/oauth2/openid/gitea/.well-known/openid-configuration";
        KANIDM_SCOPES                       = "openid email profile";
      };
    };
  };

  systemd.services.gitea-oauth-setup = {
    description = "Ensure Gitea Kanidm OAuth2 auth source exists and matches sops secret";
    after    = [ "gitea.service" "sops-install-secrets.service" ];
    wants    = [ "gitea.service" "sops-install-secrets.service" ];
    requires = [ "gitea.service" ];

    path = with pkgs; [ coreutils gawk gitea ];

    serviceConfig = {
      Type            = "oneshot";
      RemainAfterExit = true;
      User            = "gitea";
      Group           = "gitea";
      # systemd reads the file as root, hands it to gitea via $CREDENTIALS_DIRECTORY
      LoadCredential  = "gitea-oidc-secret:${config.sops.secrets.gitea-oidc-secret.path}";
      ExecStart = pkgs.writeShellScript "gitea-oauth-setup" ''
        set -euo pipefail

        GITEA_CONFIG="/var/lib/gitea/custom/conf/app.ini"
        GITEA_WORK="/var/lib/gitea"
        SECRET="$(cat "$CREDENTIALS_DIRECTORY/gitea-oidc-secret")"
        NAME="kanidm"
        DISCOVERY="https://auth.${domain}/oauth2/openid/gitea/.well-known/openid-configuration"

        # `|| true` on the pipeline so `set -e` + `pipefail` doesn't abort
        # when awk finds no match (first run, no existing source).
        EXISTING_ID="$(gitea admin auth list \
          --config "$GITEA_CONFIG" \
          --work-path "$GITEA_WORK" \
          | awk -v name="$NAME" '$2 == name { print $1 }' \
          | head -n1 || true)"

        if [ -z "$EXISTING_ID" ]; then
          echo "Creating Gitea OAuth2 auth source '$NAME'"
          gitea admin auth add-oauth \
            --config "$GITEA_CONFIG" \
            --work-path "$GITEA_WORK" \
            --name "$NAME" \
            --provider "openidConnect" \
            --key "gitea" \
            --secret "$SECRET" \
            --auto-discover-url "$DISCOVERY" \
            --scopes "email profile"
        else
          echo "Updating existing Gitea OAuth2 auth source '$NAME' (id $EXISTING_ID)"
          gitea admin auth update-oauth \
            --config "$GITEA_CONFIG" \
            --work-path "$GITEA_WORK" \
            --id "$EXISTING_ID" \
            --secret "$SECRET"
        fi
      '';
    };
  };

  # ── Nextcloud ──────────────────────────────────────────────────────
  services.nextcloud = {
    enable   = true;
    package  = pkgs.nextcloud35;
    hostName = "nextcloud.${domain}";
    https    = false;
    config = {
      adminpassFile = config.sops.secrets.nextcloud-admin-password.path;
      dbtype        = "pgsql";
      # dbpassFile    = config.sops.secrets.nextcloud-db-password.path;
    };
    settings = {
      overwritehost     = "nextcloud.${domain}";
      overwriteprotocol = "https";
      overwrite.cli.url = "https://nextcloud.${domain}";
      trusted_domains   = [ "nextcloud.${domain}" "localhost" ];
      trusted_proxies   = [ "127.0.0.1" "::1" ];
    };
    extraAppsEnable = true;
    extraApps = {
      # twofactor_totp = pkgs.nextcloud35Packages.twofactor_totp;
      inherit (config.services.nextcloud.package.packages.apps) user_oidc;
    };
  };

  # ── Media stack ────────────────────────────────────────────────────
  services.immich   = {
    enable = true;
    openFirewall = true;
    mediaLocation = "/srv/media/immich";
    port = 2283;
    # settings.oauth = {
    #   enabled = true;
    #   issuerUrl = "https://auth.${domain}/oauth2/openid/immich";
    #   clientId = "immich";
    #   clientSecret = "";
    #   scope = "openid email profile";
    #   signingAlgorithm = "ES256";
    #   profileSigningAlgorithm = "none";
    #   tokenEndpointAuthMethod = "client_secret_post";
    #   storageLabelClaim = "preferred_username";
    #   roleClaim = "immich_role";
    #   storageQuotaClaim = "immich_quota";
    #   autoRegister = true;
    #   autoLaunch = false;
    #   buttonText = "Sign in with Kanidm";
    # };
  };
  services.jellyfin = { enable = true; openFirewall = true; };
  services.prowlarr = { enable = true; openFirewall = true; };
  services.seerr    = { enable = true; openFirewall = true; };
  services.whisparr = { enable = true; openFirewall = true; };
  services.sonarr   = { enable = true; openFirewall = true; };
  services.radarr   = { enable = true; openFirewall = true; };

  services.transmission = {
    enable = true;
    openFirewall = true;
    settings = {
      download-dir            = "/srv/media/downloads";
      incomplete-dir          = "/srv/media/downloads/incomplete";
      watch-dir               = "/srv/media/downloads/watch";
      watch-dir-enabled       = true;
      download-dir-free-space = 10;
    };
  };

  services.navidrome = {
    enable = true;
    settings.Port = 4533;
    openFirewall = true;
  };
  # ── Kanidm ─────────────────────────────────────────────────────────
  services.kanidm = {
    package = pkgs.kanidmWithSecretProvisioning_1_11;
    # kanidm person credential create-reset-token <username> --name idm_admin
    # sudo kanidmd recover-account idm_admin
    # kanidm login --name idm_admin
    client = {
      enable = true;
      settings = {
        uri              = authUrl;
        verify_ca        = true;
        verify_hostnames = true;
      };
    };

    server = {
      enable = true;
      settings = {
        domain          = "auth.${domain}";
        origin          = authUrl;
        bindaddress     = "127.0.0.1:8443";
        ldapbindaddress = "127.0.0.1:3636";
        tls_chain       = certFile;
        tls_key         = certKeyFile;
      };
    };

    provision = {
      enable               = true;
      instanceUrl          = authUrl;
      adminPasswordFile    = config.sops.secrets.kanidm-admin-password.path;
      idmAdminPasswordFile = config.sops.secrets.kanidm-idm-admin-password.path;

      groups = {
        gitea_users.members     = [ "feather" ];
        immich_users.members    = [ "feather" ];
        immich_admins.members   = [ "feather" ];
        nextcloud_users.members = [ "feather" ];
        seerr_users.members     = [ "feather" ];
        homarr_users.members    = [ "feather" ];
        homarr_admins.members   = [ "feather" ];
      };

      persons = {
        feather = {
          displayName   = "Feather";
          legalName     = "Feather";
          mailAddresses = [ "featherprinceyt@gmail.com" ];
          groups        = [ "gitea_users" "immich_users" "immich_admins" "nextcloud_users" "seerr_users" "homarr_users" "homarr_admins" ];
        };
        # greta = {
        #   displayName   = "Greta";
        #   legalName     = "Greta";
        #   mailAddresses = [ "hagret@gmail.com" ];
        #   groups        = [ "gitea_users" "immich_users" "immich_admins" "nextcloud_users" "seerr_users" ];
        # };
      };

      systems.oauth2 = {
        homarr = {
          displayName         = "Homarr";
          originLanding       = "https://homarr.${domain}";
          originUrl           = "https://homarr.${domain}/api/auth/callback/oidc";
          basicSecretFile     = config.sops.secrets.homarr-oidc-secret.path;
          preferShortUsername = true;
          scopeMaps.homarr_users = [ "openid" "email" "profile" "groups" ];
          claimMaps.groups = {
            joinType = "array";
            valuesByGroup.homarr_admins = [ "homarr_admins" ];
            valuesByGroup.homarr_users = [ "homarr_users" ];
          };
        };
        gitea = {
          displayName         = "Gitea";
          originLanding       = "https://git.${domain}";
          originUrl           = "https://git.${domain}/user/oauth2/kanidm/callback";
          basicSecretFile     = config.sops.secrets.gitea-oidc-secret.path;
          preferShortUsername = true;   # ← essential
          scopeMaps.gitea_users = [ "openid" "email" "profile" ];
          allowInsecureClientDisablePkce = true;
        };
        immich = {
          displayName         = "Immich";
          originLanding       = "https://immich.${domain}";
          originUrl           = "https://immich.${domain}/auth/login";
          basicSecretFile     = config.sops.secrets.immich-oidc-secret.path;
          preferShortUsername = true;
          scopeMaps.immich_users = [ "openid" "email" "profile" ];
          claimMaps.immich_role = {
            joinType = "csv";
            valuesByGroup.immich_admins = [ "admin" ];
          };
        };
        nextcloud = {
          displayName         = "Nextcloud";
          originLanding       = "https://nextcloud.${domain}";
          originUrl           = "https://nextcloud.${domain}/apps/user_oidc/code";
          basicSecretFile     = config.sops.secrets.nextcloud-oidc-secret.path;
          preferShortUsername = true;
          scopeMaps.nextcloud_users = [ "openid" "email" "profile" ];
        };
        seerr = {
          displayName         = "Seerr";
          originLanding       = "https://seerr.${domain}";
          originUrl           = "https://seerr.${domain}/api/v1/auth/oidc/callback";
          basicSecretFile     = config.sops.secrets.seerr-oidc-secret.path;
          preferShortUsername = true;
          scopeMaps.seerr_users = [ "openid" "email" "profile" ];
        };
      };
    };
  };

  # ── Nginx ──────────────────────────────────────────────────────────
  systemd.services.nginx = {
    wants = [ "acme-finished-${domain}.target" ];
    after = [ "acme-finished-${domain}.target" ];
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings   = true;
    recommendedOptimisation  = true;
    recommendedGzipSettings  = true;

    virtualHosts = {
      "_" = { default = true; locations."/".return = "404"; };

      "${domain}"           = mkProxy { port = 3000; };
      "dashboard.${domain}" = mkProxy { port = 3000; };

      # Nextcloud's own module injects the body; we only add TLS + headers
      "nextcloud.${domain}" = {
        addSSL            = true;
        sslCertificate    = certFile;
        sslCertificateKey = certKeyFile;
        extraConfig = ''
          proxy_set_header X-Forwarded-Proto https;
          proxy_set_header X-Forwarded-Port  443;
        '';
      };

      "jellyfin.${domain}"  = mkProxy { port = 8096; };
      "radarr.${domain}"    = mkProxy { port = 7878; };
      "sonarr.${domain}"    = mkProxy { port = 8989; };
      "prowlarr.${domain}"  = mkProxy { port = 9696; };
      "whisparr.${domain}"  = mkProxy { port = 6969; };
      "seerr.${domain}"     = mkProxy { port = 5055; };
      "navidrome.${domain}" = mkProxy { port = 4533; };

      "immich.${domain}" = {
        addSSL            = true;
        sslCertificate    = certFile;
        sslCertificateKey = certKeyFile;
        locations."/" = {
          proxyPass       = "http://[::1]:2283";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_set_header Host              $host;
            proxy_set_header X-Real-IP         $remote_addr;
            proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };

      "transmission.${domain}" = {
        addSSL            = true;
        sslCertificate    = certFile;
        sslCertificateKey = certKeyFile;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9091";
          extraConfig = ''
            proxy_set_header Host   $host;
            proxy_set_header Origin $scheme://$host;
          '';
        };
      };

      "git.${domain}" = {
        addSSL            = true;
        sslCertificate    = certFile;
        sslCertificateKey = certKeyFile;
        locations."/" = {
          proxyPass       = "http://127.0.0.1:3001";
          proxyWebsockets = true;
          extraConfig     = "client_max_body_size 512M;";
        };
      };

      "auth.${domain}" = {
        addSSL            = true;
        sslCertificate    = certFile;
        sslCertificateKey = certKeyFile;
        locations."/" = {
          proxyPass       = "https://127.0.0.1:8443";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host              $host;
            proxy_set_header X-Forwarded-Proto https;
            proxy_set_header X-Forwarded-Host  $host;
            proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
            proxy_ssl_verify off;
          '';
        };
      };

      "homarr.${domain}" = {
        addSSL            = true;
        sslCertificate    = certFile;
        sslCertificateKey = certKeyFile;
        locations."/" = {
          proxyPass       = "http://127.0.0.1:7575";
          proxyWebsockets = true;
        };
        extraConfig = ''
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Host $host;
        '';
      };
    };
  };

  # ── Cloudflare Tunnel ──────────────────────────────────────────────
  services.cloudflared = {
    enable = true;
    tunnels."${tunnelID}" = {
      credentialsFile = "/var/lib/cloudflared/creds.json";
      default         = "http_status:404";
      ingress = {
        "${domain}"        = { service = "http://localhost:80"; originRequest.httpHostHeader = "${domain}"; };
        "homarr.${domain}" = { service = "http://localhost:80"; originRequest.httpHostHeader = "homarr.${domain}"; };
        "*.${domain}"      = { service = "http://localhost:80"; };
      };
    };
  };

  # ── Homepage ───────────────────────────────────────────────────────
  services.homepage-dashboard = {
    enable = true;
    listenPort   = 3000;
    allowedHosts = "${domain},dashboard.${domain},dashboard,localhost,127.0.0.1";
    services = [
      { Media = [
          { Immich    = { href = "https://immich.${domain}";    icon = "immich.png";    description = "Browse your gallery"; }; }
          { Jellyfin  = { href = "https://jellyfin.${domain}";  icon = "jellyfin.png";  description = "Stream your media"; }; }
          { Seerr     = { href = "https://seerr.${domain}";     icon = "seerr.png";     description = "Request movies & shows"; }; }
          { Navidrome = { href = "https://navidrome.${domain}"; icon = "navidrome.png"; description = "Play music"; }; }
      ]; }
      { Automation = [
          { Radarr   = { href = "https://radarr.${domain}";   icon = "radarr.png"; }; }
          { Sonarr   = { href = "https://sonarr.${domain}";   icon = "sonarr.png"; }; }
          { Prowlarr = { href = "https://prowlarr.${domain}"; icon = "prowlarr.png"; }; }
      ]; }
      { Productivity = [
          { Nextcloud = { href = "https://nextcloud.${domain}"; icon = "nextcloud.png"; }; }
          { Gitea     = { href = "https://git.${domain}";       icon = "gitea.png"; }; }
      ]; }
      { Downloads = [
          { Transmission = { href = "https://transmission.${domain}"; icon = "transmission.png"; }; }
      ]; }
    ];
  };
  # ── Homarr ───────────────────────────────────────────────
  virtualisation.oci-containers.containers.homarr = {
    image = "ghcr.io/homarr-labs/homarr:latest";
    ports = [ "127.0.0.1:7575:3000" ];
    volumes = [
      "homarr-data:/appdata"
      "/var/run/docker.sock:/var/run/docker.sock:ro"  # commented out unless you want Docker integration
    ];

    # Secrets come from this file
    environmentFiles = [ config.sops.templates."homarr.env".path ];

    # Non-secret config stays here
    environment = {
      # LOG_LEVEL                   = "debug";
      AUTH_PROVIDERS              = "oidc";
      AUTH_OIDC_ISSUER            = "https://auth.${domain}/oauth2/openid/homarr";
      AUTH_OIDC_CLIENT_ID         = "homarr";
      AUTH_OIDC_CLIENT_NAME       = "Kanidm";
      AUTH_OIDC_GROUPS_ATTRIBUTE  = "groups";
      AUTH_OIDC_SCOPE_OVERWRITE   = "openid email profile groups";
      # AUTH_OIDC_SCOPE             = "openid email profile groups";
      AUTH_OIDC_ADMIN_GROUP       = "homarr_admins";
      AUTH_OIDC_AUTO_LOGIN        = "false"; # should be set to true, can be set to false for debugging
      AUTH_OIDC_FORCE_USERINFO    = "true";
      AUTH_SESSION_EXPIRY_TIME    = "30d";
      AUTH_URL                    = "https://homarr.${domain}";
      NEXTAUTH_URL                = "https://homarr.${domain}";
      # Note: AUTH_OIDC_CLIENT_SECRET and SECRET_ENCRYPTION_KEY are NOT here —
      # they come from the environmentFiles entry above.
    };
  };

  virtualisation.oci-containers.backend = "docker";
  virtualisation.docker.enable = true;

  sops.templates."homarr.env" = {
    content = ''
      AUTH_OIDC_CLIENT_SECRET=${config.sops.placeholder.homarr-oidc-secret}
      SECRET_ENCRYPTION_KEY=${config.sops.placeholder.homarr-secret-encryption-key}
    '';
    # owned by root; docker daemon reads it during container creation
    owner = "root";
    mode  = "0400";
  };
  # ── Hosts / firewall ───────────────────────────────────────────────
  networking.extraHosts = ''
    127.0.0.1 ${domain}
    127.0.0.1 auth.${domain}
    127.0.0.1 dashboard.${domain}
    127.0.0.1 git.${domain}
    127.0.0.1 immich.${domain}
    127.0.0.1 jellyfin.${domain}
    127.0.0.1 navidrome.${domain}
    127.0.0.1 nextcloud.${domain}
    127.0.0.1 prowlarr.${domain}
    127.0.0.1 radarr.${domain}
    127.0.0.1 seerr.${domain}
    127.0.0.1 sonarr.${domain}
    127.0.0.1 transmission.${domain}
    127.0.0.1 whisparr.${domain}
    127.0.0.1 homarr.${domain}
  '';

  networking.firewall.allowedTCPPorts = [ 25 80 443 ];
}

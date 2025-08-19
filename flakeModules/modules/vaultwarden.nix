top@{ lib, ... }:
{
  flake.modules.generic.vaultwarden =
    { class, config, ... }:
    lib.optionalAttrs (class == "nixos") {
      imports = with top.config.flake.modules.generic; [
        sops
        postgresql
      ];

      services.postgresql = {
        authentication = ''
          host vaultwarden vaultwarden 192.168.100.3/32 trust
          host vaultwarden vaultwarden fc00::3/128 trust
        '';
        ensureDatabases = [ "vaultwarden" ];
        ensureUsers = [
          {
            name = "vaultwarden";
            ensureDBOwnership = true;
          }
        ];
      };
      networking.firewall.interfaces."ve-vaultwarden".allowedTCPPorts = [
        config.services.postgresql.settings.port
      ];

      containers.vaultwarden = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "192.168.100.1";
        localAddress = "192.168.100.3";
        hostAddress6 = "fc00::1";
        localAddress6 = "fc00::3";

        bindMounts."${config.sops.secrets."chinos-hlb24/vaultwarden/env".path}".isReadOnly = true;

        config = containerInputs: {
          services.vaultwarden = {
            enable = true;
            dbBackend = "postgresql";
            environmentFile = config.sops.secrets."chinos-hlb24/vaultwarden/env".path;
            config = {
              DOMAIN = "https://vaultwarden.chino.dev";
              SIGNUPS_ALLOWED = false;
              ROCKET_ADDRESS = config.containers.vaultwarden.localAddress;
              DATABASE_URL = "postgresql://vaultwarden@${config.containers.vaultwarden.hostAddress}/vaultwarden";
              DATABASE_MAX_CONNS = 2; # it's only for me so no need to consume more ram
              IP_HEADER = "CF-Connecting-IP";
              SMTP_HOST = "shadow.mxrouting.net";
              SMTP_SECURITY = "force_tls";
              SMTP_PORT = 465;
              SMTP_USERNAME = "noreply@vaultwarden.chino.dev";
              SMTP_FROM = "noreply@vaultwarden.chino.dev";
              SMTP_FROM_NAME = "Chinos' Vaultwarden";
            };
          };

          systemd.tmpfiles.rules = [
            "z ${
              config.sops.secrets."chinos-hlb24/vaultwarden/env".path
            } 0440 ${containerInputs.config.users.users.vaultwarden.name} ${containerInputs.config.users.groups.vaultwarden.name} - -"
          ];

          networking = {
            firewall = {
              enable = true;
              allowedTCPPorts = [ 8000 ];
            };
            # https://github.com/NixOS/nixpkgs/issues/162686
            useHostResolvConf = lib.mkForce false;
          };
          services.resolved.enable = true;

          system.stateVersion = "24.05";
        };
      };

      sops.secrets."chinos-hlb24/vaultwarden/env" = {
        sopsFile = ../../secrets/chinos-hlb24.yaml;
      };
    };
}

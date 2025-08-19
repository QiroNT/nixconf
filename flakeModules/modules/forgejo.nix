top@{ lib, ... }:
{
  flake.modules.generic.forgejo =
    { class, config, ... }:
    lib.optionalAttrs (class == "nixos") {
      imports = with top.config.flake.modules.generic; [
        sops
        postgresql
      ];

      services.postgresql = {
        authentication = ''
          host forgejo forgejo 192.168.100.2/32 trust
          host forgejo forgejo fc00::2/128 trust
        '';
        ensureDatabases = [ "forgejo" ];
        ensureUsers = [
          {
            name = "forgejo";
            ensureDBOwnership = true;
          }
        ];
      };
      networking.firewall.interfaces."ve-forgejo".allowedTCPPorts = [
        config.services.postgresql.settings.port
      ];

      containers.forgejo = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "192.168.100.1";
        localAddress = "192.168.100.2";
        hostAddress6 = "fc00::1";
        localAddress6 = "fc00::2";

        bindMounts."${config.sops.secrets."chinos-hlb24/forgejo/mailer-password".path}".isReadOnly = true;

        config = containerInputs: {
          services.forgejo = {
            enable = true;

            database = {
              type = "postgres";
              createDatabase = false;
              host = config.containers.forgejo.hostAddress;
            };

            lfs.enable = true;
            settings = {
              server = {
                DOMAIN = "git.chino.dev";
                ROOT_URL = "https://git.chino.dev/";
                HTTP_PORT = 3000;
                LANDING_PAGE = "explore";
              };

              security.INSTALL_LOCK = true;
              service.DISABLE_REGISTRATION = true;

              # note: cloudflare has a limit of 100
              "repository.upload".FILE_MAX_SIZE = 50;
              attachment.MAX_SIZE = 50;

              actions = {
                ENABLED = true;
                DEFAULT_ACTIONS_URL = "https://code.forgejo.org";
              };

              mailer = {
                ENABLED = true;
                PROTOCOL = "smtps";
                SMTP_ADDR = "shadow.mxrouting.net";
                SMTP_PORT = 465;
                FROM = "noreply@git.chino.dev";
                USER = "noreply@git.chino.dev";
              };
            };
            secrets.mailer.PASSWD = config.sops.secrets."chinos-hlb24/forgejo/mailer-password".path;
          };

          systemd.tmpfiles.rules = [
            "z ${
              config.sops.secrets."chinos-hlb24/forgejo/mailer-password".path
            } 0440 ${containerInputs.config.services.forgejo.user} ${containerInputs.config.services.forgejo.group} - -"
          ];

          networking = {
            firewall = {
              enable = true;
              allowedTCPPorts = [ 3000 ];
            };
            # https://github.com/NixOS/nixpkgs/issues/162686
            useHostResolvConf = lib.mkForce false;
          };
          services.resolved.enable = true;

          system.stateVersion = "24.05";
        };
      };

      sops.secrets."chinos-hlb24/forgejo/mailer-password" = {
        sopsFile = ../../secrets/chinos-hlb24.yaml;
      };
    };
}

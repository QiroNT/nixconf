{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.services.factorio;
in
{
  options.${namespace}.services.factorio = with lib.types; {
    enable = lib.mkEnableOption "factorio";
  };

  config = lib.mkIf cfg.enable {
    chinos.sops.enable = true;

    containers.factorio = {
      autoStart = true;

      privateNetwork = true;
      hostAddress = "192.168.100.1";
      localAddress = "192.168.100.6";
      hostAddress6 = "fc00::1";
      localAddress6 = "fc00::6";
      forwardPorts = [
        {
          protocol = "udp";
          hostPort = 34197;
          containerPort = 34197;
        }
      ];

      bindMounts."${config.sops.secrets."chinos-hlb24/factorio/server-settings.json".path}".isReadOnly =
        true;

      config = containerInputs: {
        nixpkgs.config.allowUnfree = true;

        services.factorio = {
          enable = true;
          openFirewall = true;
          lan = true;
          game-name = "Chinos' Factorio";
          admins = [ "QiroNT" ];
          nonBlockingSaving = true;
          autosave-interval = 4;
          loadLatestSave = true;
          extraSettingsFile = config.sops.secrets."chinos-hlb24/factorio/server-settings.json".path;
        };

        networking = {
          firewall.enable = true;
          # https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };
        services.resolved.enable = true;

        system.stateVersion = "24.05";
      };
    };

    sops.secrets."chinos-hlb24/factorio/server-settings.json" = {
      sopsFile = ../../../../secrets/chinos-hlb24.yaml;
    };
  };
}

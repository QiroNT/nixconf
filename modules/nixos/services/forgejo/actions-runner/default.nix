{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.services.forgejo.actions-runner;
in
{
  options.${namespace}.services.forgejo.actions-runner = with lib.types; {
    enable = lib.mkEnableOption "forgejo actions runner";
  };

  config = lib.mkIf cfg.enable {
    chinos = {
      sops.enable = true;
    };

    containers.forgejo-ar = {
      autoStart = true;

      privateNetwork = true;
      hostAddress = "192.168.100.1";
      localAddress = "192.168.100.5";
      hostAddress6 = "fc00::1";
      localAddress6 = "fc00::5";

      bindMounts."${config.sops.secrets."chinos-hlb24/forgejo/actions-runner/token".path}".isReadOnly =
        true;

      config = containerInputs: {
        services.gitea-actions-runner = {
          package = pkgs.forgejo-actions-runner;
          instances.default = {
            enable = true;
            name = "chinos-hlb24";
            url = "https://git.chino.dev";
            # Obtaining the path to the runner token file may differ
            tokenFile = config.sops.secrets."chinos-hlb24/forgejo/actions-runner/token".path;
            labels = [
              "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-latest"
              "ubuntu-22.04:docker://ghcr.io/catthehacker/ubuntu:act-22.04"
              "ubuntu-20.04:docker://ghcr.io/catthehacker/ubuntu:act-20.04"
            ];
          };
        };

        virtualisation.docker = {
          enable = true;
          storageDriver = "btrfs";
        };

        systemd.tmpfiles.rules = [
          "z ${config.sops.secrets."chinos-hlb24/forgejo/actions-runner/token".path} 0440 root root - -"
        ];

        networking = {
          firewall.enable = true;
          # https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };
        services.resolved.enable = true;

        system.stateVersion = "24.05";
      };
    };

    sops.secrets."chinos-hlb24/forgejo/actions-runner/token" = {
      sopsFile = ../../../../../secrets/chinos-hlb24.yaml;
    };
  };
}

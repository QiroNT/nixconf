{ config, ... }:
let
  composeDir = "${config.home-manager.users.qiront.programs.nh.osFlake}/hosts/x86_64-nixos/chinos-hlb24/docker";

  services = [
    "magpie"
    "llama-swap"
  ];
in
{
  imports = [
    ./immich
    ./magpie
  ];

  systemd.services.docker-compose-update = {
    description = "Pull and recreate auto-updated docker compose services";
    after = [
      "docker.service"
      "network-online.target"
    ];
    requires = [ "docker.service" ];
    wants = [ "network-online.target" ];
    path = [ config.virtualisation.docker.package ];

    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = composeDir;
    };

    script = ''
      docker compose pull ${toString services}
      docker compose up -d ${toString services}
      docker image prune -f
    '';
  };

  systemd.timers.docker-compose-update = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 05:00:00";
      RandomizedDelaySec = "10m";
      Persistent = true;
    };
  };
}

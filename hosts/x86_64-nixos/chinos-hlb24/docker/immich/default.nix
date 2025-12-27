{ self, config, ... }:
let
  port = 2283;
in
{
  imports = with self.modules.nixos; [ sops ];

  sops.secrets."chinos-hlb24/immich/env" = {
    owner = config.users.users.qiront.name;
    group = config.users.users.qiront.group;
    sopsFile = "${self}/secrets/chinos-hlb24.yaml";
  };

  systemd.services.tailscale-serve-immich = {
    after = [ "tailscaled.service" ];
    wantedBy = [ "tailscaled.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${config.services.tailscale.package}/bin/tailscale serve --service=svc:immich --http=80 ${builtins.toString port}";
      ExecStop = "${config.services.tailscale.package}/bin/tailscale serve drain svc:immich";
      RestartSec = 10;
      Restart = "on-failure";
      RemainAfterExit = true;
    };
  };
}

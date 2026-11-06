{
  self,
  config,
  ...
}:
let
  port = 3430;
in
{
  imports = with self.modules.nixos; [ sops ];

  systemd.tmpfiles.rules = [
    "d /opt/magpie/config 0700 65532 65532 - -"
  ];

  sops.secrets."chinos-hlb24/magpie/env" = {
    owner = config.users.users.qiront.name;
    group = config.users.users.qiront.group;
    sopsFile = "${self}/secrets/chinos-hlb24.yaml";
  };

  systemd.services.tailscale-serve-magpie = {
    after = [ "tailscaled.service" ];
    wantedBy = [ "tailscaled.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${config.services.tailscale.package}/bin/tailscale serve --service=svc:magpie --http=80 ${toString port}";
      ExecStop = "${config.services.tailscale.package}/bin/tailscale serve drain svc:magpie";
      RestartSec = 10;
      Restart = "on-failure";
      RemainAfterExit = true;
    };
  };
}

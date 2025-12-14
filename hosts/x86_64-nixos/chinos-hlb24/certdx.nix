{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  clientServices = [ "caddy.service" ];
in
{
  imports = with inputs.self.modules.nixos; [ sops ];

  # https://github.com/ParaParty/certdx/blob/main/systemd-service/certdx-server.service
  systemd.services.certdx-server = {
    wantedBy = clientServices;
    before = clientServices;
    after = [ "network-online.target" ];

    serviceConfig = {
      Restart = "always";
      RestartSec = 3;
      DynamicUser = true;
      StateDirectory = "certdx";
      WorkingDirectory = "/var/lib/certdx";
      ExecStart = "${pkgs.local.certdx-server} --conf server-config.toml";
    };
  };

  sops.secrets =
    let
      files = [
        "server-config.toml"
        "mtls/ca.pem"
        "mtls/server.key"
        "mtls/server.pem"
      ];
      conf =
        file:
        lib.nameValuePair "chinos-hlb24/certdx/${file}" {
          sopsFile = ../../../secrets/chinos-hlb24.yaml;
          path = "/var/lib/certdx/${file}";
          restartUnits = [ "certdx-server.service" ];
        };
    in
    files |> map conf |> builtins.listToAttrs;
}

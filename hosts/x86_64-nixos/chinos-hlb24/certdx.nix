{
  self,
  lib,
  pkgs,
  ...
}:
let
  clientServices = [ "caddy.service" ];

  secretFiles = [
    "server-config.toml"
    "mtls/ca.pem"
    "mtls/server.key"
    "mtls/server.pem"
  ];
  secretMapping =
    secretFiles
    |> map (file: lib.nameValuePair file (builtins.replaceStrings [ "/" "." ] [ "-" "-" ] file))
    |> builtins.listToAttrs;
in
{
  imports = with self.modules.nixos; [ sops ];

  # https://github.com/ParaParty/certdx/blob/main/systemd-service/certdx-server.service
  systemd.services.certdx-server = {
    wantedBy = clientServices;
    before = clientServices;

    serviceConfig = {
      Restart = "always";
      RestartSec = 3;
      DynamicUser = true;
      StateDirectory = "certdx";
      WorkingDirectory = "/var/lib/certdx";
      LoadCredential =
        secretFiles |> map (file: "${secretMapping.${file}}:/run/secrets/chinos-hlb24/certdx/${file}");
      ExecStartPre = pkgs.writeShellScript "certdx-server-pre" ''
        mkdir -p mtls private

        chmod 0750 private

        chmod -R 0750 mtls
        ${
          secretFiles
          |> map (file: "cat $CREDENTIALS_DIRECTORY/${secretMapping.${file}} > ${file}")
          |> lib.join "\n"
        }
        chmod 0440 mtls/*
        chmod 0550 mtls

        if [ ! -f cache.json ]; then
          echo {} > cache.json
        fi
        chmod 0640 cache.json
      '';
      ExecStart = "${pkgs.local.certdx-server}/bin/certdx-server --conf server-config.toml";
      ExecStartPost = pkgs.writeShellScript "certdx-server-post" ''
        while ! ${pkgs.netcat}/bin/nc -z localhost 17381; do
          sleep 0.1
        done
      '';
    };
  };

  sops.secrets =
    let
      conf =
        file:
        lib.nameValuePair "chinos-hlb24/certdx/${file}" {
          sopsFile = "${self}/secrets/chinos-hlb24.yaml";
          owner = "nobody";
          group = "nogroup";
          restartUnits = [ "certdx-server.service" ];
        };
    in
    secretFiles |> map conf |> builtins.listToAttrs;
}

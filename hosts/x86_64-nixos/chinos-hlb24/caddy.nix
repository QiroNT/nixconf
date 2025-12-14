{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  certdxPort = 17381;
  caddyCertdxData = "/var/lib/caddy-certdx";
in
{
  imports = with inputs.self.modules.nixos; [ sops ];

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "pkg.para.party/certdx/exec/caddytls@v0.4.2" ];
      hash = "sha256-DNBamzNg3XTKWponqoeP7MoC0u/x4B/EAz2pV3Rv0R8=";
    };

    # logFormat = lib.mkForce "level INFO";

    globalConfig =
      let
        cert = name: ''
          certificate nixos-caddy-${name} {
            ${name}.internal.chino.dev
          }
        '';
      in
      ''
        auto_https off
        certdx {
          http {
            main_server {
              url https://certdx.internal.chino.dev:${builtins.toString certdxPort}
              authMethod mtls
              ca ${caddyCertdxData}/mtls/ca.pem
              certificate ${caddyCertdxData}/mtls/client.pem
              key ${caddyCertdxData}/mtls/client.key
            }
          }
          ${cert "immich"}
        }
      '';

    virtualHosts =
      let
        certdx = name: ''
          tls {
            get_certificate certdx nixos-caddy-${name}
          }
        '';
      in
      {
        "immich.internal.chino.dev".extraConfig = certdx "immich" + ''
          reverse_proxy http://localhost:2283
        '';
      };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  sops.secrets =
    let
      files = [
        "mtls/ca.pem"
        "mtls/client.key"
        "mtls/client.pem"
      ];
      conf =
        file:
        lib.nameValuePair "chinos-hlb24/caddy-certdx/${file}" {
          sopsFile = ../../../secrets/chinos-hlb24.yaml;
          path = "${caddyCertdxData}/${file}";
          owner = config.users.users.caddy.name;
          group = config.users.users.caddy.group;
          restartUnits = [ "caddy.service" ];
        };
    in
    files |> map conf |> builtins.listToAttrs;
}

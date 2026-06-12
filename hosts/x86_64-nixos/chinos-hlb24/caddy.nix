{
  self,
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
  imports = with self.modules.nixos; [ sops ];

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "pkg.para.party/certdx/exec/caddytls@v0.5.0" ];
      hash = "sha256-FH9ggo5oOSOdu9U+jh/r0HMMnHSRk1rYlQnZxR3IAnw=";
    };
    openFirewall = true;

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
              url https://certdx.internal.chino.dev:${toString certdxPort}
              authMethod mtls
              ca ${caddyCertdxData}/mtls/ca.pem
              certificate ${caddyCertdxData}/mtls/client.pem
              key ${caddyCertdxData}/mtls/client.key
            }
          }
          ${cert "immich"}
          ${cert "llm"}
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
        "llm.internal.chino.dev".extraConfig = certdx "llm" + ''
          reverse_proxy http://localhost:11434
        '';
      };
  };

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
          sopsFile = "${self}/secrets/chinos-hlb24.yaml";
          path = "${caddyCertdxData}/${file}";
          owner = config.users.users.caddy.name;
          group = config.users.users.caddy.group;
          restartUnits = [ "caddy.service" ];
        };
    in
    files |> map conf |> builtins.listToAttrs;
}

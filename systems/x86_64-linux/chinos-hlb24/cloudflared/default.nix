{ config, ... }:
{
  chinos = {
    sops.enable = true;
    services.cloudflared.enable = true;
  };

  services.cloudflared.tunnels."c8e37f0d-6903-4298-988a-e9fbbf79481f" = {
    credentialsFile = config.sops.secrets."chinos-hlb24/cloudflared/creds-file".path;
    default = "http_status:404";
    ingress = {
      "git.chino.dev" = "http://${config.containers.forgejo.localAddress}:3000";
      "vaultwarden.chino.dev" = "http://${config.containers.vaultwarden.localAddress}:8000";
      "minecraft-startech.chino.dev" = "tcp://localhost:25565";
    };
  };

  sops.secrets."chinos-hlb24/cloudflared/creds-file" = {
    sopsFile = ../../../../secrets/chinos-hlb24.yaml;
    owner = config.services.cloudflared.user;
    group = config.services.cloudflared.group;
  };
}

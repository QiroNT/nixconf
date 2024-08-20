{ config, ... }:
{
  chinos = {
    sops.enable = true;
    cloudflared.enable = true;
  };

  services.cloudflared.tunnels."f30b6232-eeb8-40e5-b224-0c5e5d1f4012" = {
    credentialsFile = config.sops.secrets."chinos-hlb24/cloudflared/creds-file".path;
    default = "http_status:404";
  };

  sops.secrets."chinos-hlb24/cloudflared/creds-file" = {
    sopsFile = ../../../../secrets/chinos-hlb24.yaml;
    owner = config.services.cloudflared.user;
    group = config.services.cloudflared.group;
  };
}

{ config, ... }:
{
  chinos.sops.enable = true;

  networking.wg-quick.interfaces.wg-cattery.configFile =
    config.sops.secrets."chinos-hlb24/wg-client/wg-cattery.conf".path;

  sops.secrets."chinos-hlb24/wg-client/wg-cattery.conf" = {
    sopsFile = ../../../secrets/chinos-hlb24.yaml;
  };
}
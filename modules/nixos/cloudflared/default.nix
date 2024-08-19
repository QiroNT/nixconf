{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.cloudflared;
in
{
  options.${namespace}.cloudflared = with lib.types; {
    enable = lib.mkEnableOption "cloudflared";
  };

  config = lib.mkIf cfg.enable { services.cloudflared.enable = true; };
}

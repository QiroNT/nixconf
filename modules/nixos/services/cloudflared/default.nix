{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.services.cloudflared;
in
{
  options.${namespace}.services.cloudflared = with lib.types; {
    enable = lib.mkEnableOption "cloudflared";
  };

  config = lib.mkIf cfg.enable { services.cloudflared.enable = true; };
}

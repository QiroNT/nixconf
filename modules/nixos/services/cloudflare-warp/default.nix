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
  options.${namespace}.services.cloudflare-warp = with lib.types; {
    enable = lib.mkEnableOption "cloudflare-warp";
  };

  config = lib.mkIf cfg.enable {
    # https://developers.cloudflare.com/warp-client/get-started/linux/
    services.cloudflare-warp.enable = true;
  };
}

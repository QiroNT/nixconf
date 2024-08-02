{
  lib,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.wireless;
in {
  options.${namespace}.wireless = with lib.types; {
    enable = lib.mkEnableOption "Enable wireless support";
  };

  config = lib.mkIf cfg.enable {
    networking = {
      wireless.iwd.enable = true;
      networkmanager.wifi.backend = "iwd";
    };
  };
}

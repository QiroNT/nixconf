{
  lib,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.wireless;
in {
  options.${namespace}.wireless = with types; {
    enable = mkEnableOption "Enable wireless support";
  };

  config = mkIf cfg.enable {
    networking = {
      wireless.iwd.enable = true;
      networkmanager.wifi.backend = "iwd";
    };
  };
}

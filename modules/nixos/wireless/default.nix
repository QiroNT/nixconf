{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.wireless;
in
{
  options.${namespace}.wireless = with lib.types; {
    enable = lib.mkEnableOption "wireless support";
  };

  config = lib.mkIf cfg.enable {
    networking = {
      # Received error during CMD_TRIGGER_SCAN: Operation not supported (95)
      # Received Deauthentication event, reason: 4, from_ap: false
      # https://bugzilla.kernel.org/show_bug.cgi?id=203709#c94
      networkmanager.wifi.powersave = false;
    };
  };
}

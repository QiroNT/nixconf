{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.bluetooth;
in
{
  options.${namespace}.bluetooth = with lib.types; {
    enable = lib.mkEnableOption "bluetooth";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}

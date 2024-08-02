{
  lib,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.suites.desktop;
in {
  options.${namespace}.suites.desktop = with lib.types; {
    enable = lib.mkEnableOption "Enable the desktop suite";
  };

  config =
    lib.mkIf cfg.enable {
    };
}

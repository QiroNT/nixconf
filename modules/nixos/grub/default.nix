{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.grub;
in
{
  options.${namespace}.grub = with lib.types; {
    enable = lib.mkEnableOption "grub";
  };

  config = lib.mkIf cfg.enable {
    boot.loader.grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
    };
  };
}

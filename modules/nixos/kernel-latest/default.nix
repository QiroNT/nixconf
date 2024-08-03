{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.kernel-latest;
in
{
  options.${namespace}.kernel-latest = with lib.types; {
    enable = lib.mkEnableOption "the latest kernel";
  };

  config = lib.mkIf cfg.enable { boot.kernelPackages = pkgs.linuxPackages_latest; };
}

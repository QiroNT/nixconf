{
  lib,
  pkgs,
  namespace,
  config,
  system,
  ...
}:
let
  cfg = config.${namespace}.cli.devtools;
in
{
  config = lib.mkIf (cfg.enable && lib.snowfall.system.is-linux system) {
    home.packages = with pkgs; [
      # c
      gcc
    ];
  };
}

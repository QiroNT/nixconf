{
  lib,
  pkgs,
  namespace,
  config,
  system,
  ...
}:
let
  cfg = config.${namespace}.cli.tldr;
in
{
  options.${namespace}.cli.tldr = with lib.types; {
    enable = lib.mkEnableOption "tlrc (tldr client) and tldr pages";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = with pkgs; [ tlrc ];
    })

    (lib.mkIf (cfg.enable && lib.snowfall.system.is-linux system) {
      services.tldr-update = {
        enable = true;
        package = pkgs.tlrc;
      };
    })
  ];
}

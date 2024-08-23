{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.services.postgresql;
in
{
  options.${namespace}.services.postgresql = with lib.types; {
    enable = lib.mkEnableOption "postgresql";
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      enableJIT = true;
      enableTCPIP = true;
      package = pkgs.postgresql_16;
    };
  };
}

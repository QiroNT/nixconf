{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.binfmt;
in
{
  options.${namespace}.binfmt = with lib.types; {
    enable = lib.mkEnableOption "binfmt";
  };

  config = lib.mkIf cfg.enable { boot.binfmt.emulatedSystems = [ "aarch64-linux" ]; };
}

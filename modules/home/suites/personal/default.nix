{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.suites.personal;
in
{
  options.${namespace}.suites.personal = with lib.types; {
    enable = lib.mkEnableOption "the personal suite";
  };

  config = lib.mkIf cfg.enable {
    chinos = {
      cli = {
        devtools.enable = true;
        nix-index.enable = true;
      };
    };
  };
}

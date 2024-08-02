{
  lib,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.suites.common;
in {
  options.${namespace}.suites.common = with lib.types; {
    enable = lib.mkEnableOption "the common suite";
  };

  config = lib.mkIf cfg.enable {
    chinos = {
      cli = {
        enable = true;
        git.enable = true;
        devtools.enable = true;
        nix-index.enable = true;
      };
    };

    # let home-manager install and manage itself
    programs.home-manager.enable = true;
  };
}

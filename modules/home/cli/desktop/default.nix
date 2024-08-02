{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.cli.desktop;
in {
  options.${namespace}.cli.desktop = with lib.types; {
    enable = lib.mkEnableOption "gui specific cli configurations";
  };

  config = lib.mkIf cfg.enable {
    # terminal of choice
    home.packages = with pkgs; [wezterm];
    xdg.configFile.wezterm = {
      source = ./config/wezterm;
      recursive = true;
    };
  };
}

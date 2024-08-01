{
  lib,
  pkgs,
  namespace,
  config,
  system,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.suites.desktop;
in {
  config = mkIf (cfg.enable && snowfall.system.is-linux system) {
    programs = {
      # the linux browser (TM)
      firefox = {
        enable = true;
        package = pkgs.firefox-devedition-bin;
      };

      # i'd rather like to configure in vscode and use config sync,
      # since changes are mostly gui based
      vscode.enable = true;

      # player for things that vlc can't
      mpv.enable = true;

      # recording tool (lol)
      obs-studio.enable = true;
    };
  };
}

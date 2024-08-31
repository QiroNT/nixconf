{
  lib,
  pkgs,
  namespace,
  config,
  system,
  ...
}:
let
  cfg = config.${namespace}.suites.desktop;
in
{
  options.${namespace}.suites.desktop = with lib.types; {
    enable = lib.mkEnableOption "the desktop suite";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      chinos = {
        cli.desktop.enable = true;
      };
    })

    (lib.mkIf (cfg.enable && lib.snowfall.system.is-linux system) {
      home.packages = with pkgs; [
        # apps
        audacity
        bitwarden-desktop
        bottles
        filezilla
        geogebra6
        gimp
        gparted
        heroic
        inkscape-with-extensions
        jetbrains.idea-community-bin
        libreoffice-qt6-fresh
        obsidian
        piper
        protonup-qt
        qbittorrent
        qq
        r2modman
        signal-desktop
        syncplay
        telegram-desktop
        ventoy-full
        vesktop
        vlc
        zed-editor
      ];

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
    })
  ];
}

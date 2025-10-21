{
  self,
  lib,
  config,
  ...
}:
{
  flake.modules.homeManager.qiront-profile-desktop =
    { class, pkgs, ... }:
    {
      imports = [
        {
          imports = with self.lib.prefixWith "qiront" config.flake.modules.homeManager; [
            ghostty
            gtk
            niri
          ];
        }

        (lib.optionalAttrs (class == "nixos") {
          home.packages = with pkgs; [
            # apps
            audacity
            bitwarden-desktop
            bottles
            element-desktop
            filezilla
            gale
            geogebra6
            gimp
            gparted
            heroic
            inkscape-with-extensions
            jetbrains.idea-community-bin
            monero-gui
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
              package = pkgs.firefox-devedition;
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

        (lib.optionalAttrs (class == "darwin") {

        })
      ];
    };
}

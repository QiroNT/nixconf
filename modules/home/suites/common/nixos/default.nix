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
  cfg = config.${namespace}.suites.common;
in {
  config = mkIf (cfg.enable && snowfall.system.is-linux system) {
    home = {
      packages = with pkgs; [
        # common lib
        libsecret # for git credentials

        # cli stuff
        kwalletcli
        p7zip
        rime-cli
        gcc
        psmisc # killall

        # java
        jdk

        # disk stuff
        ifuse # for ios
        mtools # NTFS
        nfs-utils # nfs

        # network
        cloudflared # tunnel
        cloudflare-warp
        tailscale
        inetutils # telnet / ping

        # apps
        audacity
        bitwarden-desktop
        filezilla
        geogebra6
        gimp
        gparted
        heroic
        inkscape-with-extensions
        jetbrains.idea-community-bin
        libreoffice-qt6-fresh
        obsidian
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
    };

    programs = {
      zsh.initExtra = ''
        # pnpm
        export PNPM_HOME="/home/qiront/.local/share/pnpm"
        case ":$PATH:" in
          *":$PNPM_HOME:"*) ;;
          *) export PATH="$PNPM_HOME:$PATH" ;;
        esac
        # pnpm end
      '';

      git.extraConfig = {
        credential.helper = "/etc/profiles/per-user/$(whoami)/bin/git-credential-libsecret";
      };
    };
  };
}

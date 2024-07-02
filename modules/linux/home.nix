{pkgs, ...}: {
  imports = [
    ../shared/home.nix
  ];

  home = {
    packages = with pkgs; [
      # common lib
      libsecret # for git credentials

      # cli stuff
      kwalletcli
      ollama # llm
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
      telegram-desktop
      filezilla
      geogebra6
      gimp
      inkscape-with-extensions
      gparted
      heroic
      jetbrains.idea-community-bin
      obsidian
      protonup-qt
      qbittorrent
      qq
      r2modman
      syncplay
      ventoy-full
      vesktop
      vlc
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
}

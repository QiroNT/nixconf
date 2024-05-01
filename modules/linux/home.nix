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

  programs.git.extraConfig = {
    credential.helper = "/etc/profiles/per-user/$(whoami)/bin/git-credential-libsecret";
  };

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      rime
    ];
  };

  # the linux browser (TM)
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition-bin;
  };

  # i'd rather like to configure in vscode and use config sync,
  # since changes are mostly gui based
  programs.vscode.enable = true;

  # player for things that vlc can't
  programs.mpv.enable = true;

  # recording tool (lol)
  programs.obs-studio.enable = true;
}

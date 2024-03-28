{pkgs, ...}: {
  imports = [
    ../shared/home.nix
    ./programs/theme.nix
    ./programs/waybar
  ];

  home = {
    packages = with pkgs; [
      # hyprland stuff
      kdePackages.qtwayland # qt compat
      libsForQt5.qt5.qtwayland
      kdePackages.dolphin # file manager, yes kde stuff doesn't need plasma
      kdePackages.polkit-kde-agent-1 # polkit agent
      swaynotificationcenter # notifications
      kitty # terminal for hyprland
      wofi # launcher
      swww # wallpaper

      # theme
      nwg-look # gtk
      kdePackages.qt6ct
      libsForQt5.qt5ct

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
      qq
      obsidian
      qbittorrent
      r2modman
      syncplay
      ventoy-full
      vlc
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings.exec-once = [
      "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
    ];
    extraConfig = builtins.readFile ./config/hypr/hyprland.conf;
  };

  # keyring
  services.gnome-keyring.enable = true;

  programs.git.extraConfig = {
    credential.helper = "/etc/profiles/per-user/$(whoami)/bin/git-credential-libsecret";
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      kdePackages.fcitx5-configtool
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

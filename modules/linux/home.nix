{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ../shared/home.nix
    ./programs/theme.nix
    ./programs/waybar.nix
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
      adw-gtk3
      qogir-icon-theme
      morewaita-icon-theme

      libsecret # for git credentials

      # cli stuff
      kwalletcli
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

  # the linux browser (TM)
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition-bin;
  };

  # i'd rather like to configure in vscode and use config sync,
  # since changes are mostly gui based
  programs.vscode.enable = true;

  # command not found in nix
  programs.nix-index.enable = true;
}

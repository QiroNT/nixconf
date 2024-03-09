{config, ...}: {
  imports = [
    ../../modules/linux/home.nix
  ];

  home.file = {
    "${config.xdg.configHome}/hypr/hyprland.local.conf".source = ./settings/hyprland.local.conf;
    "${config.xdg.configHome}/hypr/hyprpaper.conf".source = ./settings/hyprpaper.conf;
  };
}

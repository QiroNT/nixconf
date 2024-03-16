{config, ...}: {
  imports = [
    ../../modules/linux/home.nix
  ];

  home.file = {
    "${config.xdg.configHome}/hypr/hyprland.local.conf".source = ./config/hypr/hyprland.local.conf;
  };
}

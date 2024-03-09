{pkgs, ...}: {
  imports = [
    ../shared/home.nix
  ];

  home = {
    packages = with pkgs; [
      kitty # terminal for hyprland
    ];
  };

  wayland.windowManager.hyprland.enable = true;
}

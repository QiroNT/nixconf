{pkgs, ...}: {
  imports = [
    ../shared/home.nix
  ];

  home = {
    packages = with pkgs; [
      kitty # terminal for hyprland
      kdePackages.dolphin # file manager, yes kde stuff doesn't need plasma
      wofi # launcher
    ];
  };

  wayland.windowManager.hyprland.enable = true;
}

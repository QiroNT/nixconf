{pkgs, ...}: {
  imports = [
    ../shared/home.nix
  ];

  home = {
    packages = with pkgs; [
      swaynotificationcenter # notifications
      kitty # terminal for hyprland
      kdePackages.dolphin # file manager, yes kde stuff doesn't need plasma
      wofi # launcher
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./settings/hyprland.conf;
  };
}

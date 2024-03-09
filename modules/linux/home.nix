{pkgs, ...}: {
  imports = [
    ../shared/home.nix
  ];

  home = {
    packages = with pkgs; [
      # hyprland stuff
      swaynotificationcenter # notifications
      kitty # terminal for hyprland
      kdePackages.dolphin # file manager, yes kde stuff doesn't need plasma
      wofi # launcher
      hyprpaper # wallpaper

      libsecret # for git credentials
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./settings/hyprland.conf;
  };

  programs.waybar = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./settings/waybar.jsonc);
  };

  programs.git.extraConfig = {
    credential.helper = "/etc/profiles/per-user/$(whoami)/bin/git-credential-libsecret";
  };
}

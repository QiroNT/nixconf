{pkgs, ...}: {
  imports = [
    ../shared/home.nix
    ./programs/waybar.nix
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
    extraConfig = builtins.readFile ./config/hypr/hyprland.conf;
  };

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
}

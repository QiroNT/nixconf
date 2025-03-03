{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.suites.desktop;
in
{
  options.${namespace}.suites.desktop = with lib.types; {
    enable = lib.mkEnableOption "the desktop suite";
  };

  config = lib.mkIf cfg.enable {
    chinos = {
      kde.enable = true;
    };

    # packages installed in system profile. to search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages = with pkgs; [ ];

    fonts.fontDir.enable = true;

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [ fcitx5-rime ];
      };
    };

    # sound
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # printing
    services.printing.enable = true;

    # the app that maximizes my retention
    programs.steam.enable = true;
    hardware.graphics.enable32Bit = true;

    # controller
    # hardware.xone.enable = true;
    hardware.xpadneo.enable = true;

    # mouse config (piper)
    services.ratbagd.enable = true;
  };
}

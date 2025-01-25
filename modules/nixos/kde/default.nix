{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.kde;
in
{
  options.${namespace}.kde = with lib.types; {
    enable = lib.mkEnableOption "kde";
  };

  config = lib.mkIf cfg.enable {
    # desktop environment
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    services.desktopManager.plasma6.enable = true;
    services.xserver.enable = true;

    # disable by prefixing "NIXOS_OZONE_WL= " before a command
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = with pkgs; [
      kdePackages.filelight
    ];

    # i actually only use this for clipboard sync
    programs.kdeconnect.enable = true;
  };
}

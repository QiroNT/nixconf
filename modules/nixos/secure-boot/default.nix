{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.secure-boot;
in
{
  options.${namespace}.secure-boot = with lib.types; {
    enable = lib.mkEnableOption "secure boot & tpm";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      loader = {
        efi.canTouchEfiVariables = lib.mkForce false;
        systemd-boot.enable = lib.mkForce false;
      };
      lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };
      initrd.systemd.enable = true;
    };
  };
}

{ lib, ... }:
{
  imports = [ ./hardware.nix ];

  # this doesn't need to be touched,
  # touching it will definitely break things, so beware
  system.stateVersion = "24.05";

  # fix file system options
  fileSystems = {
    "/nix".options = [ "noatime" ];
    "/boot".options = [
      "noatime"
      "errors=remount-ro"
    ];
  };
  swapDevices = [
    {
      device = "/swapfile";
      size = builtins.floor (4.5 * 1024);
    }
  ];

  networking.hostName = "chinos-hlb24"; # first homelab

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_US.UTF-8";

  chinos = {
    wireless.enable = true;
    suites = {
      common.enable = true;
    };
  };
}

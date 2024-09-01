{ ... }:
{
  imports = [
    ./hardware.nix
    ./cloudflared
  ];

  # this doesn't need to be touched,
  # touching it will definitely break things, so beware
  system.stateVersion = "24.05";

  # fix file system options
  fileSystems = {
    "/nix".options = [ "noatime" ];
    "/swap".options = [ "noatime" ];
    "/boot".options = [
      "noatime"
      "errors=remount-ro"
    ];
  };
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = builtins.floor (4.5 * 1024);
    }
  ];

  networking.hostName = "chinos-hlb24"; # first homelab

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = "enp1s0";
  };

  chinos = {
    wireless.enable = true;
    services = {
      cloudflare-warp.enable = true;
      forgejo.enable = true;
      vaultwarden.enable = true;
    };
    suites = {
      common.enable = true;
    };
  };
}

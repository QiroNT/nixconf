{ ... }:
{
  imports = [ ./hardware.nix ];

  # this doesn't need to be touched,
  # touching it will definitely break things, so beware
  system.stateVersion = "24.05";

  boot.initrd.kernelModules = [ "amdgpu" ];

  # fix file system options
  fileSystems = {
    "/".options = [ "compress=lzo" ];
    "/home".options = [ "compress=lzo" ];
    "/nix".options = [
      "compress=lzo"
      "noatime"
    ];
    # fix: Mount point '/boot' which backs the random seed file is world accessible, which is a security hole!
    "/boot".options = [
      "noatime"
      "fmask=0137"
      "dmask=0027"
      "errors=remount-ro"
    ];
  };

  networking.hostName = "chinos-twr20"; # tower pc built in 2020, get it?

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  chinos = {
    suites = {
      common.enable = true;
      personal.enable = true;
      desktop.enable = true;
    };
  };
}

{
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  imports = [./hardware-configuration.nix];

  # this doesn't need to be touched,
  # touching it will definitely break things, so beware
  system.stateVersion = "24.05";

  boot.initrd.kernelModules = ["amdgpu"];

  # fix file system options
  fileSystems = {
    "/".options = ["compress=lzo"];
    "/home".options = ["compress=lzo"];
    "/nix".options = ["compress=lzo" "noatime"];
    "/boot".options = ["noatime" "errors=remount-ro"];
  };

  # technically given, but half built myself
  networking.hostName = "chinos-twr24";

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  chinos = {
    wireless.enable = true;
    suites = {
      common.enable = true;
      desktop.enable = true;
    };
  };
}

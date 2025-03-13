{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./hardware.nix ];

  # this doesn't need to be touched,
  # touching it will definitely break things, so beware
  system.stateVersion = "24.05";

  # fix file system options
  fileSystems = {
    "/".options = [ "compress=lzo" ];
    "/home".options = [ "compress=lzo" ];
    "/nix".options = [
      "compress=lzo"
      "noatime"
    ];
    "/swap".options = [ "noatime" ];
    "/boot".options = [
      "noatime"
      "errors=remount-ro"
    ];
  };
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = builtins.floor (68.5 * 1024);
    }
  ];

  # technically given, but half built myself
  networking.hostName = "chinos-twr24";

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_US.UTF-8";

  # nvidia driver
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_13;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    open = false; # perf reasons
    modesetting.enable = true;
    nvidiaSettings = true;
  };

  # https://github.com/NixOS/nixpkgs/issues/133715
  environment.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
  };

  chinos = {
    binfmt.enable = true;
    wireless.enable = true;
    bluetooth.enable = true;
    secure-boot.enable = true;
    suites = {
      common.enable = true;
      personal.enable = true;
      desktop.enable = true;
    };
  };
}

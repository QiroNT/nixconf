{ inputs, ... }:
{
  imports = with inputs.self.modules.nixos; [
    profile-desktop
    profile-personal

    users-qiront

    binfmt
    bluetooth
    kernel-cachyos
    secure-boot
    wireless

    ./hardware.nix
  ];

  # this doesn't need to be touched,
  # touching it will definitely break things, so beware
  system.stateVersion = "24.05";

  # fix file system options
  fileSystems = {
    "/".options = [ "compress=zstd:1" ];
    "/home".options = [ "compress=zstd:1" ];
    "/nix".options = [
      "compress=zstd:1"
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

  home-manager.users.qiront = import ./homes/qiront.nix;

  # technically given, but half built myself
  networking.hostName = "chinos-twr24";

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_US.UTF-8";

  # nvidia driver
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    open = true;
    modesetting.enable = true;
    nvidiaSettings = true;
  };

  # https://github.com/NixOS/nixpkgs/issues/133715
  environment.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
  };
}

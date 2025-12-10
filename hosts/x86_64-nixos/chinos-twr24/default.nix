{ inputs, pkgs, ... }:
{
  imports = with inputs.self.modules.nixos; [
    profile-desktop
    profile-personal

    users-qiront

    binfmt
    bluetooth
    secure-boot
    wireless

    ./hardware.nix
  ];

  # this doesn't need to be touched,
  # touching it will definitely break things, so beware
  system.stateVersion = "24.05";

  boot = {
    kernelPackages = pkgs.linuxPackages_6_17;
    kernelModules = [ "rtw89_8852be" ];
    extraModprobeConfig = ''
      options rtw89_pci disable_aspm_l1=y disable_aspm_l1ss=y disable_clkreq=y
      options rtw89_core disable_ps_mode=y
    '';
  };

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

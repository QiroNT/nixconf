inputs @ {
  nixpkgs,
  home-manager,
  ...
}: let
  configuration = {...}: {
    imports = [
      ../../modules/linux/configuration.nix
      # ./hardware-configuration.nix
    ];

    # this doesn't need to be touched,
    # touching it will definitely break things, so beware
    system.stateVersion = "24.05";

    # use systemd-boot as the bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # fix file system options
    fileSystems = {
      "/".options = ["compress=lzo"];
      "/home".options = ["compress=lzo"];
      "/nix".options = ["compress=lzo" "noatime"];
      # fix: Mount point '/boot' which backs the random seed file is world accessible, which is a security hole!
      "/boot".options = ["noatime" "fmask=0137" "dmask=0027" "errors=remount-ro"];
    };

    networking.hostName = "chinos-twr20"; # tower pc built in 2020, get it?

    time.timeZone = "Asia/Shanghai";
    i18n.defaultLocale = "en_US.UTF-8";

    home-manager = {
      extraSpecialArgs = {
        inherit inputs;
      };
      useUserPackages = true;
      useGlobalPkgs = true;
      users.qiront.imports = [
        ../../modules/linux/home.nix
      ];
    };
  };
in
  nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
    };
    modules = [
      home-manager.nixosModules.home-manager
      configuration
    ];
  }

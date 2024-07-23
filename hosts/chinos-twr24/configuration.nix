inputs @ {
  nixpkgs,
  home-manager,
  ...
}: let
  configuration = {...}: {
    imports = [
      ../../modules/linux/configuration.nix
      ./hardware-configuration.nix
    ];

    # this doesn't need to be touched,
    # touching it will definitely break things, so beware
    system.stateVersion = "24.05";

    boot = {
      initrd.kernelModules = ["amdgpu"];
      loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          enable = true;
          devices = ["nodev"];
          efiSupport = true;
          useOSProber = true;
        };
      };
    };

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

    users.users.qiront = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # for sudo
        "docker"
      ];
    };

    home-manager = {
      extraSpecialArgs = {
        inherit inputs;
      };
      useUserPackages = true;
      useGlobalPkgs = true;
      users.qiront.imports = [
        ./home.nix
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

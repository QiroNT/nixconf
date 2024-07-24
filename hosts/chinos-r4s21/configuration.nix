inputs @ {
  nixpkgs,
  home-manager,
  ...
}: let
  configuration = {...}: {
    imports = [
      ../../modules/linux/configuration.nix # TODO should extend a minimal one
    ];

    # this doesn't need to be touched,
    # touching it will definitely break things, so beware
    system.stateVersion = "24.05";

    # since we're building images, this needs to be specified
    nixpkgs.config.allowUnsupportedSystem = true;
    nixpkgs.hostPlatform.system = "aarch64-linux";
    nixpkgs.buildPlatform.system = "x86_64-linux";

    home-manager.users.qiront.imports = [../../modules/linux/home.nix];
  };
in
  nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs;};
    modules = [
      "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      home-manager.darwinModules.home-manager
      configuration
    ];
  }

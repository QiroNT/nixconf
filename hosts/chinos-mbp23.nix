inputs @ {
  nix-darwin,
  home-manager,
  ...
}: let
  hostPlatform = "aarch64-darwin";

  configuration = {...}: {
    imports = [
      ../modules/darwin/configuration.nix
    ];
    home-manager = {
      extraSpecialArgs = {
        inherit inputs hostPlatform;
      };
      useUserPackages = true;
      useGlobalPkgs = true;
      users.qiront.imports = [
        ../modules/darwin/home.nix
      ];
    };
    users.users.qiront.home = "/Users/qiront";
  };
in
  nix-darwin.lib.darwinSystem {
    specialArgs = {
      inherit inputs hostPlatform;
    };
    modules = [
      home-manager.darwinModules.home-manager
      configuration
    ];
  }

inputs @ {
  nix-darwin,
  home-manager,
  ...
}: let
  configuration = {...}: {
    imports = [
      ../../modules/darwin/configuration.nix
    ];

    # used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 4;

    # nix-darwin doesn't have a hardware config so..
    nixpkgs.hostPlatform = "aarch64-darwin";

    home-manager.users.qiront.imports = [../../modules/darwin/home.nix];

    users.users.qiront.home = "/Users/qiront";
  };
in
  nix-darwin.lib.darwinSystem {
    specialArgs = {inherit inputs;};
    modules = [
      home-manager.darwinModules.home-manager
      configuration
    ];
  }

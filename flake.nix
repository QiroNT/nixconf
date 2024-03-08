{
  description = "Chinos' Nix Flakes";

  inputs = {
    flake-schemas.url = "github:DeterminateSystems/flake-schemas";

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-formatter-pack = {
      url = "github:Gerschtli/nix-formatter-pack";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-schemas,
    nixpkgs,
    nix-formatter-pack,
    ...
  }: let
    linuxSystems = ["x86_64-linux" "aarch64-linux"];
    darwinSystems = ["aarch64-darwin" "x86_64-darwin"];
    forEachSystem = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;

    formatterPackArgs = forEachSystem (system: {
      inherit nixpkgs system;

      checkFiles = [./.];

      config = {
        tools = {
          alejandra.enable = true;
          deadnix.enable = true;
          statix.enable = true;
        };
      };
    });
  in {
    inherit inputs;

    inherit (flake-schemas) schemas;

    # nix-formatter-pack
    checks = forEachSystem (system: {
      nix-formatter-pack-check = nix-formatter-pack.lib.mkCheck formatterPackArgs.${system};
    });
    formatter = forEachSystem (system: nix-formatter-pack.lib.mkFormatter formatterPackArgs.${system});

    # build darwin flake using:
    darwinConfigurations = {
      # $ darwin-rebuild switch --flake ~/.config/nix-darwin#chinos-mbp23
      "chinos-mbp23" = import ./hosts/chinos-mbp23 inputs;
    };
  };
}

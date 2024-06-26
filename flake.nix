{
  description = "Chinos' Nix Flakes";

  inputs = {
    flake-schemas.url = "github:DeterminateSystems/flake-schemas";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # cache for unfree pkgs
    nixpkgs = {
      url = "github:numtide/nixpkgs-unfree";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable"; # TODO idk
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
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
          statix = {
            enable = true;
            disabledLints = (fromTOML (builtins.readFile ./statix.toml)).disabled;
          };
        };
      };
    });
  in rec {
    inherit inputs;

    inherit (flake-schemas) schemas;

    # nix-formatter-pack
    checks = forEachSystem (system: {
      nix-formatter-pack-check = nix-formatter-pack.lib.mkCheck formatterPackArgs.${system};
    });
    formatter = forEachSystem (system: nix-formatter-pack.lib.mkFormatter formatterPackArgs.${system});

    darwinConfigurations = {
      # $ darwin-rebuild switch --flake ~/.config/nix-darwin#chinos-mbp23
      "chinos-mbp23" = import ./hosts/chinos-mbp23/configuration.nix inputs;
    };

    nixosConfigurations = {
      # $ sudo nixos-rebuild switch --flake ~/.config/nix-config#chinos-twr20
      "chinos-twr20" = import ./hosts/chinos-twr20/configuration.nix inputs;
      # $ sudo nixos-rebuild switch --flake ~/.config/nix-config#chinos-r4s21
      "chinos-r4s21" = import ./hosts/chinos-r4s21/configuration.nix inputs;
    };

    images = {
      # $ nix build .#images.chinos-r4s21
      "chinos-r4s21" = nixosConfigurations."chinos-r4s21".config.system.build.sdImage;
    };
  };
}

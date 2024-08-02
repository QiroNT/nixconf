{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
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

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.; # root dir

      snowfall = {
        namespace = "chinos";
        meta = {
          name = "chinos-flake";
          title = "Chinos' Nix Flakes";
        };
      };
    };

    shared-modules = builtins.attrValues (lib.snowfall.module.create-modules {src = ./modules/shared;});
  in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [
        ];
      };

      systems.modules.nixos = shared-modules;

      systems.modules.darwin = shared-modules;

      homes.modules = with inputs; [
        nix-index-database.hmModules.nix-index
      ];

      systems.hosts = {
        "chinos-r4s21".modules = with inputs; [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        ];
      };

      # nix-formatter-pack
      outputs-builder = channels: let
        formatterPackArgs = rec {
          pkgs = channels.nixpkgs;
          inherit (pkgs) system;

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
        };
      in {
        checks.nix-formatter-pack-check = lib.nix-formatter-pack.mkCheck formatterPackArgs;
        formatter = lib.nix-formatter-pack.mkFormatter formatterPackArgs;
      };
    };
}

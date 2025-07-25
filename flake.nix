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

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    satisfactory-server-flake = {
      url = "github:nekowinston/satisfactory-server-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm = {
      url = "github:wez/wezterm?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
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

      shared-modules = builtins.attrValues (
        lib.snowfall.module.create-modules {
          src = lib.snowfall.fs.get-file "modules/shared";
        }
      );
    in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "ventoy-1.1.05" ];
      };

      systems = {
        modules = {
          nixos =
            shared-modules
            ++ (with inputs; [
              lanzaboote.nixosModules.lanzaboote
              sops-nix.nixosModules.sops
            ]);
          darwin =
            shared-modules
            ++ (with inputs; [
              sops-nix.darwinModules.sops
            ]);
          install-iso = shared-modules;
          sd-aarch64 = shared-modules;
        };
        hosts = {
          "chinos-r4s21".modules = with inputs; [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ];
        };
      };

      homes.modules = with inputs; [ nix-index-database.homeModules.nix-index ];

      outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt-rfc-style; };
    };
}

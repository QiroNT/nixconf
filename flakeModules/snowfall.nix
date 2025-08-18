{ inputs, ... }:
let
  lib = inputs.snowfall-lib.mkLib {
    inherit inputs;
    src = ../.; # root dir

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
{
  flake = lib.mkFlake {
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

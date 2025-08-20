{ lib, inputs, ... }:
{
  imports = [ inputs.easy-hosts.flakeModule ];

  easy-hosts = {
    autoConstruct = true;
    path = builtins.path { path = ../..; } + "/hosts";

    perClass = class: {
      specialArgs = {
        inherit class;
      };
      modules =
        [ ]
        ++ (lib.optionals (class == "nixos") [
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
        ])
        ++ (lib.optionals (class == "darwin") [
          inputs.home-manager.darwinModules.home-manager
          inputs.sops-nix.darwinModules.sops
        ]);
    };
  };
}

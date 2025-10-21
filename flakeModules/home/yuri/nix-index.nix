{ inputs, ... }:
{
  flake.modules.homeManager.yuri-nix-index =
    { ... }:
    {
      imports = [ inputs.nix-index-database.homeModules.nix-index ];

      programs = {
        nix-index.enable = true; # command-not-found
        nix-index-database.comma.enable = true; # , -> nix run nixpkgs#
      };
    };
}

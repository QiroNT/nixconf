{ lib, ... }:
{
  flake.modules.homeManager.niri =
    { inputs', class, ... }:
    lib.optionalAttrs (class == "nixos") {
      programs.quickshell = {
        enable = true;
        package = inputs'.noctalia.packages.default;
      };
    };
}

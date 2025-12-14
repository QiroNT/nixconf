{ inputs, withSystem, ... }:
{
  imports = [ inputs.pkgs-by-name-for-flake-parts.flakeModule ];

  perSystem =
    { ... }:
    {
      pkgsDirectory = ../../packages;
      pkgsNameSeparator = "-";
    };

  flake = {
    overlays.default =
      final: prev:
      withSystem prev.stdenv.hostPlatform.system (
        { config, ... }:
        {
          local = config.packages;
        }
      );
  };
}

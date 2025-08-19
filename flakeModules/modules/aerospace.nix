{ lib, ... }:
{
  flake.modules.generic.aerospace =
    { class, pkgs, ... }:
    lib.optionalAttrs (class == "darwin") {
      environment.systemPackages = with pkgs; [
        aerospace
      ];
    };
}

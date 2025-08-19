{ lib, ... }:
{
  flake.modules.generic.bluetooth =
    { class, pkgs, ... }:
    lib.optionalAttrs (class == "nixos") {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
    };
}

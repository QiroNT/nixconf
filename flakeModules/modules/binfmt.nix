{ lib, ... }:
{
  flake.modules.generic.binfmt =
    { class, pkgs, ... }:
    lib.optionalAttrs (class == "nixos") {
      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    };
}

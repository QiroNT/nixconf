{ lib, ... }:
{
  flake.modules.generic.kernel-latest =
    { class, pkgs, ... }:
    lib.optionalAttrs (class == "nixos") {
      boot.kernelPackages = pkgs.linuxPackages_latest;
    };
}

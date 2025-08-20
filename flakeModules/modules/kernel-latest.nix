{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "kernel-latest" (
    { class, pkgs, ... }:
    lib.optionalAttrs (class == "nixos") {
      boot.kernelPackages = pkgs.linuxPackages_latest;
    }
  );
}

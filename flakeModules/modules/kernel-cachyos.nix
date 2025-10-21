{
  self,
  lib,
  inputs,
  ...
}:
{
  flake.modules = self.lib.mkAny "kernel-cachyos" (
    { class, pkgs, ... }:
    lib.optionalAttrs (class == "nixos") {
      imports = [ inputs.chaotic.nixosModules.default ];
      boot.kernelPackages = pkgs.linuxPackages_cachyos;
    }
  );
}

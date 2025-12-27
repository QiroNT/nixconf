{ self, ... }:
{
  flake.modules = self.lib.mkAnyNixos "kernel-latest" (
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_latest;
    }
  );
}

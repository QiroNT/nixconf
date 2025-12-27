{ self, ... }:
{
  flake.modules = self.lib.mkAnyNixos "bluetooth" (
    { ... }:
    {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
    }
  );
}

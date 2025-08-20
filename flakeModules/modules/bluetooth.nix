{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "bluetooth" (
    { class, ... }:
    lib.optionalAttrs (class == "nixos") {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
    }
  );
}

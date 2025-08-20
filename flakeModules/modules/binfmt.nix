{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "binfmt" (
    { class, ... }:
    lib.optionalAttrs (class == "nixos") {
      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    }
  );
}

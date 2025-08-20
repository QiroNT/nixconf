{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "aerospace" (
    { class, pkgs, ... }:
    lib.optionalAttrs (class == "darwin") {
      environment.systemPackages = with pkgs; [
        aerospace
      ];
    }
  );
}

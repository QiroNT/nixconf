{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "sunshine" (
    { class, ... }:
    lib.optionalAttrs (class == "nixos") {
      services.sunshine = {
        enable = true;
        autoStart = false;
        capSysAdmin = true;
        openFirewall = true;
      };
    }
  );
}

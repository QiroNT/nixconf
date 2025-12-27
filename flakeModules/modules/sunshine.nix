{ self, ... }:
{
  flake.modules = self.lib.mkAnyNixos "sunshine" (
    { ... }:
    {
      services.sunshine = {
        enable = true;
        autoStart = false;
        capSysAdmin = true;
        openFirewall = true;
      };
    }
  );
}

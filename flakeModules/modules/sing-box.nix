{ self, lib, ... }:
{
  flake.modules = self.lib.mkAnyNixos "sing-box" (
    { ... }:
    {
      services.sing-box.enable = true;
      systemd.services.sing-box.wantedBy = lib.mkForce [ ];
    }
  );
}

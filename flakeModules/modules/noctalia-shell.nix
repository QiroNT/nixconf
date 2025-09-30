{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "noctalia-shell" (
    { inputs, class, ... }:
    lib.optionalAttrs (class == "nixos") {
      imports = [ inputs.noctalia-shell.nixosModules.default ];
      services.noctalia-shell.enable = true;
    }
  );
}

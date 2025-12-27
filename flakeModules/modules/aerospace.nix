{ self, ... }:
{
  flake.modules = self.lib.mkAnyDarwin "aerospace" (
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        aerospace
      ];
    }
  );
}

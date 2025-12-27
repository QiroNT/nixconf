{ self, ... }:
{
  flake.modules = self.lib.mkAnyMatch "profile-personal" (
    { class, pkgs, ... }:
    {
      any = {
        imports = with self.lib.withAny class; [
          profile-base

          docker
        ];
      };

      nixos = {
        # SUID wrapper, not sure if i need this, but just to not bother my future self
        programs.mtr.enable = true;
        programs.gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };

        # compatibility
        programs.nix-ld = {
          enable = true;
          # Add any missing dynamic libraries for unpackaged programs
          # here, NOT in environment.systemPackages
          libraries = with pkgs; [ ];
        };
      };
    }
  );
}

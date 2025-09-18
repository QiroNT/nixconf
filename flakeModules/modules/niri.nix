{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "niri" (
    {
      inputs,
      class,
      pkgs,
      ...
    }:
    lib.optionalAttrs (class == "nixos") {
      imports = [ inputs.niri.nixosModules.niri ];
      programs.niri = {
        enable = true;
        # settings = {
        #   spawn-at-startup = [
        #     { command = [ "noctalia-shell" ]; }
        #   ];
        # };
      };
      services.xserver.enable = true;
      environment.systemPackages = with pkgs; [
        xwayland-satellite
      ];
      environment.variables.NIXOS_OZONE_WL = "1";
    }
  );
}

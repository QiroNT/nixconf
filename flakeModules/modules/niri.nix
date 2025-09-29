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
      programs.niri.enable = true;
      environment.systemPackages = with pkgs; [
        wl-clipboard
        wayland-utils
        libsecret
        xwayland-satellite
        nautilus
      ];
      environment.variables.NIXOS_OZONE_WL = "1";

      security = {
        polkit.enable = true;
        pam.services.greetd.enableGnomeKeyring = true;
      };
      services.greetd = {
        enable = true;
        settings.default_session.command = ''${pkgs.tuigreet}/bin/tuigreet --time --asterisks --remember --cmd ${pkgs.writeScript "init-session" ''
          # so here we're trying to stop a previous niri session
          systemctl --user is-active niri.service && systemctl --user stop niri.service
          # and then we start a new one
          /run/current-system/sw/bin/niri-session
        ''}'';
      };
    }
  );
}

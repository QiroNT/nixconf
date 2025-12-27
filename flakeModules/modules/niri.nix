{ self, ... }:
{
  flake.modules = self.lib.mkAnyNixos "niri" (
    {
      inputs,
      config,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.niri.nixosModules.niri ];

      programs.niri.enable = true;
      environment.systemPackages = with pkgs; [
        wl-clipboard
        wayland-utils
        libsecret
        xwayland-satellite
        app2unit

        kdePackages.ark
        nautilus

        pwvucontrol
        udiskie
      ];
      environment.variables.NIXOS_OZONE_WL = "1";

      services.gnome.sushi.enable = true;
      programs.nautilus-open-any-terminal = {
        enable = true;
        terminal = "ghostty";
      };

      programs.uwsm = {
        enable = true;
        waylandCompositors.niri = {
          prettyName = "Niri";
          comment = "A scrollable-tiling Wayland compositor";
          binPath = "/run/current-system/sw/bin/niri-session";
        };
      };

      security = {
        polkit.enable = true;
        pam.services.greetd.enableGnomeKeyring = true;
      };
      services.greetd = {
        enable = true;
        useTextGreeter = true;
        settings.default_session.command = ''
          ${pkgs.tuigreet}/bin/tuigreet \
            --sessions "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions" \
            --xsessions "${config.services.displayManager.sessionData.desktops}/share/xsessions" \
            --remember \
            --remember-user-session \
            --window-padding 1 \
            --time \
            --asterisks \
            --power-shutdown "/run/current-system/systemd/bin/systemctl poweroff" \
            --power-reboot "/run/current-system/systemd/bin/systemctl reboot"
        '';
      };
    }
  );
}

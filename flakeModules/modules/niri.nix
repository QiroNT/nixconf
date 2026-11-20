{ self, ... }:
{
  flake.modules = self.lib.mkAnyNixos "niri" (
    {
      inputs,
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.niri.nixosModules.niri ];

      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };
      environment.systemPackages = with pkgs; [
        wl-clipboard
        wayland-utils
        libsecret
        xwayland-satellite
        app2unit

        kdePackages.ark
        nautilus
        nomacs

        pwvucontrol
        udiskie
      ];
      environment.variables.NIXOS_OZONE_WL = "1";

      services = {
        logind.settings.Login.HandlePowerKey = "poweroff";
        accounts-daemon.enable = true;
        geoclue2.enable = true;
        power-profiles-daemon.enable = true;
      };

      services.gnome.sushi.enable = true;
      programs.nautilus-open-any-terminal.enable = true;

      programs.uwsm = {
        enable = true;
        waylandCompositors.niri = {
          prettyName = "Niri";
          comment = "A scrollable-tiling Wayland compositor";
          binPath = "/run/current-system/sw/bin/niri-session";
        };
      };

      security = {
        polkit = {
          enable = true;
          extraConfig = ''
            polkit.addRule(function(action, subject) {
              var allowed = [
                "org.freedesktop.login1.power-off",
                "org.freedesktop.login1.power-off-multiple-sessions",
                "org.freedesktop.login1.reboot",
                "org.freedesktop.login1.reboot-multiple-sessions"
              ];
              if (subject.user == "${config.services.greetd.settings.default_session.user}" && allowed.indexOf(action.id) >= 0) {
                return polkit.Result.YES;
              }
            });
          '';
        };
        pam.services.greetd.enableGnomeKeyring = true;
      };
      services.greetd = {
        enable = true;
        useTextGreeter = true;
        settings.default_session.command = ''${lib.getExe pkgs.tuigreet} --sessions "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions" --xsessions "${config.services.displayManager.sessionData.desktops}/share/xsessions" --cmd "${lib.getExe config.programs.uwsm.package} start -F -- /run/current-system/sw/bin/niri-session" --remember --window-padding 1 --time --asterisks --power-shutdown "/run/current-system/systemd/bin/systemctl poweroff" --power-reboot "/run/current-system/systemd/bin/systemctl reboot"'';
      };
    }
  );
}

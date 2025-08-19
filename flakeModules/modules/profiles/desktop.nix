{ lib, config, ... }:
{
  flake.modules.generic.profileDesktop =
    { class, pkgs, ... }:
    {
      imports = [
        {
          imports = with config.flake.modules.generic; [
            aerospace
            fonts
            kde
          ];
        }

        (lib.optionalAttrs (class == "nixos") {
          fonts.fontDir.enable = true;

          i18n.inputMethod = {
            enable = true;
            type = "fcitx5";
            fcitx5 = {
              waylandFrontend = true;
              addons = with pkgs; [ fcitx5-rime ];
            };
          };

          # sound
          security.rtkit.enable = true;
          services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
          };

          # printing
          services.printing.enable = true;

          # the app that maximizes my retention
          programs.steam.enable = true;
          hardware.graphics.enable32Bit = true;

          # controller
          # hardware.xone.enable = true;
          hardware.xpadneo.enable = true;

          # mouse config (piper)
          services.ratbagd.enable = true;
        })

        (lib.optionalAttrs (class == "darwin") {

        })
      ];
    };
}

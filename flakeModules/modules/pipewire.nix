{ self, ... }:
{
  flake.modules = self.lib.mkAnyNixos "pipewire" (
    { ... }:
    {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        extraConfig.pipewire-pulse."15-quirks" = {
          pulse.rules = [
            {
              matches = [
                { "application.name" = "~Chromium.*"; }
                { "application.process.binary" = "Discord"; }
                { "application.process.binary" = "vesktop"; }
              ];
              actions = {
                quirks = [ "block-source-volume" ];
              };
            }
          ];
        };
      };
    }
  );
}

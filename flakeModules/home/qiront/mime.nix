{ lib, ... }:
{
  flake.modules.homeManager.qiront-mime =
    {
      class,
      config,
      pkgs,
      ...
    }:
    lib.optionalAttrs (class == "nixos") {
      xdg.mimeApps = {
        enable = true;
        defaultApplicationPackages = with pkgs; [
          nomacs
          kdePackages.ark
          nautilus

          telegram-desktop
          vesktop
          bitwarden-desktop

          config.programs.firefox.package
          zed-editor
        ];
        defaultApplications = { };
      };
    };
}

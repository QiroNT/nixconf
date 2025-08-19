{ lib, ... }:
{
  flake.modules.homeManager.wezterm =
    { class, pkgs, ... }:
    lib.optionalAttrs (class == "nixos") {
      # terminal of choice
      home.packages = with pkgs; [ wezterm ];
      xdg.configFile.wezterm = {
        source = ../../config/wezterm;
        recursive = true;
      };
    };
}

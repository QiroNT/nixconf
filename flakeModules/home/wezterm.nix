{ lib, ... }:
{
  flake.modules.homeManager.wezterm =
    { class, pkgs, ... }:
    lib.optionalAttrs (class == "nixos") {
      # terminal of choice
      programs.wezterm = {
        enable = true;
        package = pkgs.wezterm;
        extraConfig = builtins.readFile ../../config/wezterm/wezterm.lua;
      };
    };
}

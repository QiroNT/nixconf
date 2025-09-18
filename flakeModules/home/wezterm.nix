{ lib, ... }:
{
  flake.modules.homeManager.wezterm =
    { class, pkgs, ... }:
    lib.optionalAttrs (class == "nixos") {
      # terminal of choice
      programs.wezterm = {
        enable = true;
        packages = pkgs.wezterm;
        extraConfig = builtins.readFile ../../config/wezterm/wezterm.lua;
      };
    };
}

{ lib, ... }:
{
  flake.modules.homeManager.qiront-helix =
    { pkgs, ... }:
    {
      programs.helix = {
        enable = true;
        defaultEditor = true;
        settings = {
          editor = {
            line-number = "relative";
            cursor-shape = {
              normal = "block";
              insert = "bar";
              select = "underline";
            };
          };
        };
        languages = {
          language = [
            {
              name = "nix";
              auto-format = true;
              formatter.command = "${lib.getExe pkgs.nixfmt}";
            }
          ];
        };
      };
    };
}

{ lib, ... }:
{
  flake.modules.homeManager.helix =
    { pkgs, ... }:
    {
      programs.helix = {
        enable = true;
        settings = {
          theme = lib.mkDefault "monokai";
          editor.cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
          editor.soft-wrap = {
            enable = true;
            max-wrap = 25;
            max-indent-retain = 0;
            wrap-indicator = "";
          };
        };
        languages.language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
          }
        ];
      };
    };
}

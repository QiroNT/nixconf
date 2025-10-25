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
            color-modes = true;
            bufferline = "multiple";
            line-number = "relative";
            rulers = [
              80
              120
            ];
            indent-guides.render = true;
            cursor-shape = {
              normal = "block";
              insert = "bar";
              select = "underline";
            };
            end-of-line-diagnostics = "hint";
            inline-diagnostics.cursor-line = "warning";
          };
          keys.normal = {
            esc = [
              "collapse_selection"
              "keep_primary_selection"
            ];
          };
        };
        languages = {
          language = [
            {
              name = "nix";
              auto-format = true;
              formatter.command = "${lib.getExe pkgs.nixfmt}";
            }
            {
              name = "typst";
              auto-format = true;
            }
          ];
          language-server = {
            tinymist.config = {
              formatterProseWrap = true;
            };
            rust-analyzer.config = {
              check.command = "clippy";
            };
          };
        };
        extraPackages = with pkgs; [
          nixd
          rust-analyzer
          tinymist # typst
          typstyle
          vscode-langservers-extracted # html/css/json/eslint
          clang-tools # c
          lldb
        ];
      };
    };
}

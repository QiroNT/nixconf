{ self, lib, ... }:
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
          language =
            let
              cfg = {
                nix = {
                  auto-format = true;
                  formatter.command = "${lib.getExe pkgs.nixfmt}";
                };
                typst = {
                  auto-format = true;
                };
              };

              codebook-langs = [
                "c"
                "cpp"
                "css"
                "html"
                "javascript"
                "lua"
                "markdown"
                "nix"
                "python"
                "rust"
                "toml"
                "typescript"
                "zig"
              ];
              codebook-cfg =
                codebook-langs
                |> map (l: lib.nameValuePair l { language-servers.__append = [ "codebook" ]; })
                |> builtins.listToAttrs;
            in
            self.lib.infuse cfg [
              codebook-cfg
            ]
            |> lib.mapAttrsToList (name: value: value // { inherit name; });

          language-server = {
            tinymist.config = {
              formatterProseWrap = true;
            };
            rust-analyzer.config = {
              check.command = "clippy";
            };
            codebook = {
              command = "codebook-lsp";
              args = [ "serve" ];
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
          codebook # spell check
        ];
      };
    };
}

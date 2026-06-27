{ self, lib, ... }:
{
  flake.modules.homeManager.qiront-helix =
    { pkgs, ... }:
    {
      programs.helix = {
        enable = true;
        defaultEditor = true;

        settings =
          let
            tty-popup =
              cmd:
              pkgs.writeShellScript "tty-popup" ''
                if [[ -n $ZELLIJ ]]; then
                  TTY_W_TMP=$(mktemp -d)

                  zellij run -fc --blocking --width 90% --height 90% -x 5% -y 5% -- \
                    sh -c "${cmd} $@ > $TTY_W_TMP/out"

                  cat "$TTY_W_TMP/out"
                  rm -rf "$TTY_W_TMP"
                else
                  # use the system stty if possible to fix permission issue on macos
                  STTY=stty
                  if [ -f /bin/stty ]; then
                    STTY=/bin/stty
                  fi

                  {
                    # save and restore tty settings
                    SAVED_TTY=$($STTY -g)
                    $STTY sane

                    ${cmd} $@
                    
                    $STTY "$SAVED_TTY"
                  } < /dev/tty
                fi
              '';
          in
          {
            editor = {
              color-modes = true;
              bufferline = "multiple";
              line-number = "relative";
              rulers = [
                80
                120
              ];
              whitespace.render = {
                tab = "all";
              };
              indent-guides = {
                render = true;
                character = "▏"; # left align
                skip-levels = 1; # so that one tab can be rendered
              };
              cursor-shape = {
                normal = "block";
                insert = "bar";
                select = "underline";
              };
              # TODO: find a way to only hide `codebook` info
              # and change back to `hint`
              end-of-line-diagnostics = "warning";
              inline-diagnostics.cursor-line = "warning";
            };

            keys.normal = {
              esc = [
                "collapse_selection"
                "keep_primary_selection"
              ];
            };

            keys.normal.space = {
              # replace file explorer with yazi
              e =
                let
                  yazi-chooser = pkgs.writeShellScript "yazi-chooser" ''
                    ${pkgs.yazi}/bin/yazi $1 --chooser-file=/dev/stdout
                  '';
                in
                [
                  ":set mouse false"
                  ":open %sh{${tty-popup yazi-chooser} '%{buffer_name}'}"
                  ":redraw"
                  ":set mouse true"
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

              default-language-servers =
                (fromTOML (
                  builtins.readFile "${
                    pkgs.helix-unwrapped.src.override { sparseCheckout = [ "languages.toml" ]; }
                  }/languages.toml"
                )).language
                |> builtins.filter (
                  l: builtins.hasAttr "name" l && builtins.hasAttr "scope" l && builtins.hasAttr "language-servers" l
                )
                |> map (l: lib.nameValuePair l.name { language-servers = _: l.language-servers; })
                |> builtins.listToAttrs;

              codebook-langs = [
                "astro"
                "bash"
                "c"
                "c-sharp"
                "cpp"
                "css"
                "dart"
                "elixir"
                "erlang"
                "go"
                "haskell"
                "html"
                "java"
                "javascript"
                "lua"
                "nix"
                "ocaml"
                "ocaml-interface"
                "odin"
                "php"
                "python"
                "ruby"
                "rust"
                "svelte"
                "swift"
                "toml"
                "typescript"
                "vhdl"
                "vue"
                "yaml"
                "zig"
              ];
              harper-langs = [
                "markdown"
                "typst"
              ];

              append-ls =
                server: langs:
                langs
                |> map (l: lib.nameValuePair l { language-servers.__append = [ server ]; })
                |> builtins.listToAttrs;
            in
            self.lib.infuse cfg [
              default-language-servers
              (append-ls "codebook" codebook-langs)
              (append-ls "harper-ls" harper-langs)
            ]
            |> lib.mapAttrsToList (name: value: value // { inherit name; });

          language-server = {
            tinymist.config = {
              formatterMode = "typstyle";
              formatterProseWrap = true;
            };
            rust-analyzer.config = {
              check.command = "clippy";
            };
            codebook = {
              command = "codebook-lsp";
              args = [ "serve" ];
            };
            harper-ls = {
              command = "harper-ls";
              args = [ "--stdio" ];
            };
          };
        };

        extraPackages = with pkgs; [
          # nix
          nixd
          # rust
          rust-analyzer
          # typst
          tinymist
          typstyle
          # html/css/json/eslint
          vscode-langservers-extracted
          # c
          clang-tools
          lldb
          # java
          jdt-language-server
          # spell check
          codebook
          harper
        ];
      };
    };
}

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
                yazi-wrapper = pkgs.writeShellScript "yazi-wrapper" ''
                  if [[ -n $ZELLIJ ]]; then
                    YAZI_TMP=$(mktemp -d)

                    mkfifo "$YAZI_TMP/fifo"

                    zellij run -fc --width 90% --height 90% -x 5% -y 5% -- \
                      sh -c "${pkgs.yazi}/bin/yazi \"$1\" --chooser-file=\"$YAZI_TMP/out\" | tee \"$YAZI_TMP/fifo\""

                    cat < "$YAZI_TMP/fifo" > /dev/null

                    cat "$YAZI_TMP/out"
                    rm -rf "$YAZI_TMP"
                  else
                    # use the system stty if possible to fix permission issue
                    # on macos
                    STTY=stty
                    if [ -f /bin/stty ]; then
                      STTY=/bin/stty
                    fi

                    # save and restore tty settings
                    # the "official" version fixes settings by using stuff like
                    # `x1b[?1049h]`, which is not what helix uses exactly.
                    # this script just save and restores it instead.
                    SAVED_TTY=$($STTY -g < /dev/tty)
                    $STTY sane < /dev/tty

                    ${pkgs.yazi}/bin/yazi "$1" --chooser-file=/dev/stdout

                    $STTY "$SAVED_TTY" < /dev/tty
                  fi
                '';
              in
              [
                ":set mouse false"
                ":open %sh{${yazi-wrapper} '%{buffer_name}'}"
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
                (builtins.fromTOML (builtins.readFile ./config/helix/default-languages.toml)).language
                |> builtins.filter (
                  l: builtins.hasAttr "name" l && builtins.hasAttr "scope" l && builtins.hasAttr "language-servers" l
                )
                |> map (l: lib.nameValuePair l.name { language-servers = _: l.language-servers; })
                |> builtins.listToAttrs;

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
              default-language-servers
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

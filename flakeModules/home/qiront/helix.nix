{ ... }:
{
  flake.modules.homeManager.qiront-helix =
    { inputs', pkgs, ... }:
    let
      helix = inputs'.helix-steel.packages.helix.overrideAttrs (old: {
        buildFeatures = (old.buildFeatures or [ ]) ++ [
          "git"
          "steel"
        ];
      });
      steel = inputs'.steel.packages.steel;
      helix-chinos = pkgs.local.helix-chinos.override { inherit steel; };

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

            restore_tty() {
              "$STTY" "$SAVED_TTY" < /dev/tty
              printf "\x1b[?1049h\x1b[?2004h\x1b[?1004h" > /dev/tty
            }

            {
              SAVED_TTY=$($STTY -g)
              trap restore_tty EXIT HUP INT TERM
              $STTY sane

              ${cmd} $@

              restore_tty
              trap - EXIT HUP INT TERM
            } < /dev/tty
          fi
        '';
    in
    {
      programs.helix = {
        enable = true;
        defaultEditor = true;
        package = helix.overrideAttrs (prevAttrs: {
          cargoBuildFeatures = [
            "helix-term/steel"
          ];
        });

        settings = {
          editor = {
            true-color = true; # zellij forces this anyways
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
        };

        extraPackages = with pkgs; [
          # scheme
          racket
          schemat
          # nix
          nixd
          nixfmt
          # rust
          rust-analyzer
          # typst
          tinymist
          typstyle
          # html/css/json/eslint
          vscode-langservers-extracted
          vue-language-server
          astro-language-server
          svelte-language-server
          # c
          clang-tools
          lldb
          # java
          jdt-language-server
          # markdown
          rumdl
          # spell check
          codebook
          harper
        ];
      };

      home.packages = [
        steel
      ];

      xdg.configFile."helix" = {
        source =
          pkgs.runCommand "helix-config"
            {
              gituPath =
                pkgs.writeShellScript "gitu-popup" ''
                  ${pkgs.gitu}/bin/gitu > /dev/tty
                ''
                |> tty-popup;

              lazygitPath =
                pkgs.writeShellScript "lazygit-popup" ''
                  ${pkgs.lazygit}/bin/lazygit > /dev/tty
                ''
                |> tty-popup;

              yaziPath =
                pkgs.writeShellScript "yazi-chooser" ''
                  ${pkgs.yazi}/bin/yazi $1 --chooser-file=/dev/stdout
                ''
                |> tty-popup;
            }
            ''
              cp -r ${./config/helix} $out
              chmod -R u+w $out

              shopt -s globstar nullglob

              for file in "$out"/**/*; do
                [[ -f "$file" ]] || continue
                substituteAllInPlace "$file"
              done
            '';
        recursive = true;
      };

      xdg.dataFile."steel/native" =
        let
          native = pkgs.symlinkJoin {
            name = "steel-native";
            paths = [
              helix-chinos
            ];
          };
        in
        {
          source = "${native}/share/steel/native";
          recursive = true;
        };
    };
}

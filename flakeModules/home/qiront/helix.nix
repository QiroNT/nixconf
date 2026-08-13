{ inputs, ... }:
{
  flake.modules.homeManager.qiront-helix =
    { pkgs, ... }:
    let
      helix = inputs.helix-steel.packages.${pkgs.stdenv.hostPlatform.system}.helix;
      steel = inputs.steel.packages.${pkgs.stdenv.hostPlatform.system}.steel;
      helix-chinos = pkgs.local.helix-chinos.override { inherit steel; };
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

        extraPackages = with pkgs; [
          # scheme
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

      home.packages = [
        steel
      ];

      xdg.configFile."helix" = {
        source = ./config/helix;
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

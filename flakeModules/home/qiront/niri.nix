{ lib, ... }:
{
  flake.modules.homeManager.qiront-niri =
    {
      class,
      config,
      ...
    }:
    lib.optionalAttrs (class == "nixos") {
      programs = {
        niri.settings = {
          # nvidia fix, remove once either
          # https://github.com/YaLTeR/niri/issues/2030
          # https://github.com/YaLTeR/niri/issues/2477
          # is closed
          debug.wait-for-frame-completion-before-queueing = [ ];

          hotkey-overlay.skip-at-startup = true;
          prefer-no-csd = true;

          input.keyboard.numlock = true;

          layout = {
            gaps = 3;
            border.width = 2;
            background-color = "transparent";
          };

          layer-rules = [
            {
              matches = [ { namespace = "^noctalia-wallpaper*"; } ];
              place-within-backdrop = true;
            }
          ];

          overview.workspace-shadow.enable = false;

          workspaces = {
            "1" = { };
            "2" = { };
            "3" = { };
            # "4" = { };
            # "5" = { };
            # "6" = { };
            # "7" = { };
            # "8" = { };
            # "9" = { };
          };

          window-rules = [
            {
              # i hate this
              geometry-corner-radius = {
                bottom-left = 3.;
                bottom-right = 3.;
                top-left = 3.;
                top-right = 3.;
              };
              clip-to-geometry = true;
            }

            {
              matches = [
                { app-id = "^firefox-devedition$"; }
              ];
              open-on-workspace = "1";
            }
            {
              matches = [
                {
                  app-id = "^com.mitchellh.ghostty$";
                  at-startup = true;
                }
              ];
              open-on-workspace = "2";
              default-column-width.proportion = 1.;
            }
            {
              matches = [
                { app-id = "^org.telegram.desktop$"; }
                { app-id = "^vesktop$"; }
              ];
              open-on-workspace = "3";
            }
          ];

          spawn-at-startup = [
            { sh = "app2unit -- firefox-devedition"; }
            { sh = ''app2unit -- ghostty -e zsh -l -c "zellij a -c defaulted"''; }
            { sh = "app2unit -- vesktop"; }
          ];

          binds =
            with config.lib.niri.actions;
            let
              binds =
                {
                  suffixes,
                  prefixes,
                  substitutions ? { },
                }:
                let
                  replacer = lib.replaceStrings (lib.attrNames substitutions) (lib.attrValues substitutions);
                  format =
                    prefix: suffix:
                    let
                      actual-suffix =
                        if lib.isList suffix.action then
                          {
                            action = lib.head suffix.action;
                            args = lib.tail suffix.action;
                          }
                        else
                          {
                            inherit (suffix) action;
                            args = [ ];
                          };

                      action = replacer "${prefix.action}-${actual-suffix.action}";
                    in
                    {
                      name = "${prefix.key}+${suffix.key}";
                      value.action.${action} = actual-suffix.args;
                    };
                  pairs =
                    attrs: fn:
                    lib.concatMap (
                      key:
                      fn {
                        inherit key;
                        action = attrs.${key};
                      }
                    ) (lib.attrNames attrs);
                in
                lib.listToAttrs (pairs prefixes (prefix: pairs suffixes (suffix: [ (format prefix suffix) ])));
            in
            lib.attrsets.mergeAttrsList [
              {
                "Mod+Shift+Slash".action = show-hotkey-overlay;

                "Mod+T".action = spawn-sh "uwsm app -- ghostty";
                "Mod+Space".action = spawn-sh "noctalia-shell ipc call launcher toggle";
                "Mod+Alt+L".action = spawn-sh "noctalia-shell ipc call lockScreen toggle";

                "Mod+Alt+S" = {
                  action = spawn-sh "pkill orca || exec orca";
                  allow-when-locked = true;
                };

                "XF86AudioRaiseVolume" = {
                  action = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01+";
                  allow-when-locked = true;
                };
                "XF86AudioLowerVolume" = {
                  action = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01-";
                  allow-when-locked = true;
                };
                "XF86AudioMute" = {
                  action = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
                  allow-when-locked = true;
                };
                "XF86AudioMicMute" = {
                  action = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
                  allow-when-locked = true;
                };

                "XF86MonBrightnessUp" = {
                  action = spawn "brightnessctl" "--class=backlight" "set" "+5%";
                  allow-when-locked = true;
                };
                "XF86MonBrightnessDown" = {
                  action = spawn "brightnessctl" "--class=backlight" "set" "5%-";
                  allow-when-locked = true;
                };

                "Mod+O" = {
                  action = toggle-overview;
                  repeat = false;
                };

                "Mod+Q".action = close-window;

                "Mod+Tab".action = focus-workspace-previous;

                "Mod+BracketLeft".action = consume-or-expel-window-left;
                "Mod+BracketRight".action = consume-or-expel-window-right;

                "Mod+Comma".action = consume-window-into-column;
                "Mod+Period".action = expel-window-from-column;

                "Mod+R".action = switch-preset-column-width;
                "Mod+Shift+R".action = switch-preset-window-height;
                "Mod+Ctrl+R".action = reset-window-height;

                "Mod+F".action = maximize-column;
                "Mod+Shift+F".action = fullscreen-window;

                "Mod+Ctrl+F".action = expand-column-to-available-width;

                "Mod+C".action = center-column;

                "Mod+Ctrl+C".action = center-visible-columns;

                "Mod+Minus".action = set-column-width "-10%";
                "Mod+Equal".action = set-column-width "+10%";

                "Mod+Shift+Minus".action = set-window-height "-10%";
                "Mod+Shift+Equal".action = set-window-height "+10%";

                "Mod+V".action = toggle-window-floating;
                "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

                "Mod+W".action = toggle-column-tabbed-display;

                "Print".action.screenshot = [ ];
                "Ctrl+Print".action.screenshot-screen = [ ];
                "Alt+Print".action.screenshot-window = [ ];

                "Mod+Escape" = {
                  action = toggle-keyboard-shortcuts-inhibit;
                  allow-inhibiting = false;
                };

                "Mod+Shift+E".action = quit;
                "Ctrl+Alt+Delete".action = quit;

                "Mod+Shift+P".action = power-off-monitors;
              }
              (binds {
                suffixes."Left" = "column-left";
                suffixes."Down" = "window-down";
                suffixes."Up" = "window-up";
                suffixes."Right" = "column-right";
                prefixes."Mod" = "focus";
                prefixes."Mod+Ctrl" = "move";
                prefixes."Mod+Shift" = "focus-monitor";
                prefixes."Mod+Shift+Ctrl" = "move-column-to-monitor";
                substitutions."monitor-column" = "monitor";
                substitutions."monitor-window" = "monitor";
              })
              (binds {
                suffixes."Home" = "first";
                suffixes."End" = "last";
                prefixes."Mod" = "focus-column";
                prefixes."Mod+Ctrl" = "move-column-to";
              })
              (binds {
                suffixes."Page_Down" = "workspace-down";
                suffixes."Page_Up" = "workspace-up";
                prefixes."Mod" = "focus";
                prefixes."Mod+Ctrl" = "move-column-to";
                prefixes."Mod+Shift" = "move";
              })
              (binds {
                suffixes =
                  (lib.range 1 9)
                  |> map (n: {
                    name = toString n;
                    value = [
                      "workspace"
                      n
                    ];
                  })
                  |> builtins.listToAttrs;
                prefixes."Mod" = "focus";
                prefixes."Mod+Ctrl" = "move-column-to";
              })
            ];
        };
      };

      xdg.configFile."uwsm/env-niri".text = ''
        export APP2UNIT_SLICES="a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice"
        export APP2UNIT_TYPE="scope"
      '';
    };
}

{ lib, ... }:
{
  flake.modules.homeManager.qiront-paneru =
    { inputs, class, ... }:
    lib.optionalAttrs (class == "darwin") {
      imports = [
        inputs.paneru.homeModules.paneru
      ];

      services.paneru = {
        enable = true;
        settings = {
          options = {
            focus_follows_mouse = false;
            mouse_follows_focus = false;
            animation_speed = 20;
          };
          bindings = {
            window_focus_west = "alt - h";
            window_focus_east = "alt - l";
            window_swap_west = "alt + shift - h";
            window_swap_east = "alt + shift - l";

            window_resize = "alt - r";
            window_center = "alt - c";
            window_fullwidth = "alt - f";
            window_shrink = "alt - minus";
            window_grow = "alt - equal";

            window_manage = "alt - v";

            quit = "alt + ctrl - q";
          }
          // (
            (lib.range 1 9)
            |> map (n: {
              name = "window_virtualnum_" + toString n;
              value = "alt - " + toString n;
            })
            |> builtins.listToAttrs
          )
          // (
            (lib.range 1 9)
            |> map (n: {
              name = "window_virtualmovenum_" + toString n;
              value = "alt + ctrl - " + toString n;
            })
            |> builtins.listToAttrs
          );
        };
      };
    };
}

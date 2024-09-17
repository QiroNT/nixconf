{ inputs, ... }:
final: prev: {
  wezterm = inputs.wezterm.packages.${prev.system}.default;
}

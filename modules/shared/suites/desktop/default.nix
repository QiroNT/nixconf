{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.suites.desktop;
in {
  config = lib.mkIf cfg.enable {
    # fonts
    fonts.packages = with pkgs; [
      open-sans
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      source-han-sans
      source-han-serif
      geist-font
      chinos.windows-fonts

      fira-code
      fira-code-symbols
      monaspace
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "Monaspace"
        ];
      })
    ];
  };
}

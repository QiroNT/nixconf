{ ... }:
{
  flake.modules.generic.fonts =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        open-sans
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji
        source-han-sans
        source-han-serif
        geist-font
        local.windows11-fonts

        fira-code
        fira-code-symbols
        monaspace
        nerd-fonts.fira-code
        nerd-fonts.monaspace
      ];
    };
}

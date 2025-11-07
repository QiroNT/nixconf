{ self, ... }:
{
  flake.modules = self.lib.mkAny "fonts" (
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        open-sans
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        source-han-sans
        source-han-serif
        geist-font
        local.windows11-fonts

        fira-code
        fira-code-symbols
        local.monaspace
        nerd-fonts.fira-code
      ];
    }
  );
}

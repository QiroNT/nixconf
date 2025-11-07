{ self, config, ... }:
{
  flake.modules.homeManager.qiront-profile-base =
    { osConfig, ... }:
    {
      imports = with self.lib.prefixWith "qiront" config.flake.modules.homeManager; [
        cli
        git
        helix
        nh
        nix-index
        stylix
        tldr
        zellij
        zsh
      ];

      # let home-manager install and manage itself
      programs.home-manager.enable = true;

      # https://github.com/NixOS/nixpkgs/issues/224525
      xdg.enable = true;

      # would prevent conflicts with kde
      fonts.fontconfig.enable = !self.lib.hasAny osConfig "kde";
    };
}

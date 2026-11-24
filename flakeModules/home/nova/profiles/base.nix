{ self, config, ... }:
{
  flake.modules.homeManager.nova-profile-base =
    { osConfig, ... }:
    {
      imports = with self.lib.prefixWith "nova" config.flake.modules.homeManager; [
        cli
        git
        helix
        nh
        nix-index
        stylix
        tldr
      ];

      # let home-manager install and manage itself
      programs.home-manager.enable = true;

      # https://github.com/NixOS/nixpkgs/issues/224525
      xdg.enable = true;

      # would prevent conflicts with kde
      fonts.fontconfig.enable = !self.lib.hasAny osConfig "kde";
    };
}

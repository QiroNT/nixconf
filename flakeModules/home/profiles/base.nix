{ config, ... }:
{
  flake.modules.homeManager.profileBase =
    { ... }:
    {
      imports = with config.flake.modules.homeManager; [
        cli
        git
        nh
        tldr
      ];

      # let home-manager install and manage itself
      programs.home-manager.enable = true;

      # https://github.com/NixOS/nixpkgs/issues/224525
      xdg.enable = true;

      # would prevent conflicts with kde
      fonts.fontconfig.enable = false;
    };
}

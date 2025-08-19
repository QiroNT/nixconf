{ inputs, ... }:
{
  imports = with inputs.self.modules.generic; [
    profileBase
    profileDesktop
    profilePersonal
  ];

  # used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.users.qiront.home = "/Users/qiront";
  home-manager.users.qiront = import ./home.nix;
}

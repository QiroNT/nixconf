{ self, ... }:
{
  imports = with self.lib.prefixWith "qiront" self.modules.homeManager; [
    profile-base
    profile-desktop
    profile-personal
  ];

  home.stateVersion = "24.05";
}

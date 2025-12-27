{ self, ... }:
{
  imports = with self.lib.prefixWith "qiront" self.modules.homeManager; [
    profile-base
  ];

  home.stateVersion = "24.05";
}

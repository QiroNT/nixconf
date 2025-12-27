{ self, ... }:
{
  imports = with self.lib.prefixWith "yuri" self.modules.homeManager; [
    profile-base
  ];

  home.stateVersion = "24.05";
}

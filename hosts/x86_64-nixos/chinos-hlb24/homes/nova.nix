{ self, ... }:
{
  imports = with self.lib.prefixWith "nova" self.modules.homeManager; [
    profile-base
  ];

  home.stateVersion = "24.05";
}

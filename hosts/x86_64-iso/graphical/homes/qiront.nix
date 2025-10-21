{ self, inputs, ... }:
{
  imports = with self.lib.prefixWith "qiront" inputs.self.modules.homeManager; [
    profile-base
    profile-desktop
    profile-personal
  ];

  home.stateVersion = "24.11";
}

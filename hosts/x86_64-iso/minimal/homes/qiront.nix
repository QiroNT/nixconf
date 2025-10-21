{ self, inputs, ... }:
{
  imports = with self.lib.prefixWith "qiront" inputs.self.modules.homeManager; [
    profile-base
    profile-personal
  ];

  home.stateVersion = "24.11";
}

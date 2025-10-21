{ self, inputs, ... }:
{
  imports = with self.lib.prefixWith "qiront" inputs.self.modules.homeManager; [
    profile-base
  ];

  home.stateVersion = "24.05";
}

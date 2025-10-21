{ self, inputs, ... }:
{
  imports = with self.lib.prefixWith "yuri" inputs.self.modules.homeManager; [
    profile-base
  ];

  home.stateVersion = "24.05";
}

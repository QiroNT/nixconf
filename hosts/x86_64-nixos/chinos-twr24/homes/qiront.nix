{ inputs, ... }:
{
  imports = with inputs.self.modules.homeManager; [
    profileBase
    profileDesktop
    profilePersonal
  ];

  home.stateVersion = "24.05";
}

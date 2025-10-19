{ inputs, ... }:
{
  imports = with inputs.self.modules.homeManager; [
    profileBase
    profilePersonal
  ];

  home.stateVersion = "24.11";
}

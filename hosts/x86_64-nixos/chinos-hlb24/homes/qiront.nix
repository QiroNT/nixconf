{ inputs, ... }:
{
  imports = with inputs.self.modules.homeManager; [
    profileBase
  ];

  home.stateVersion = "24.05";
}

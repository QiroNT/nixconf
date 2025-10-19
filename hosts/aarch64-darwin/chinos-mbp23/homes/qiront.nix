{ inputs, ... }:
{
  imports = with inputs.self.modules.homeManager; [
    profileBase
    profileDesktop
    profilePersonal
  ];

  home.stateVersion = "24.05";

  programs.git.includes = [
    {
      condition = "gitdir:~/Projects/unsw/";
      contents = {
        user = {
          name = "Chino ZHOU";
          email = "z5645020@ad.unsw.edu.au";
        };
      };
    }
  ];
}

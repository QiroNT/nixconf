{ self, inputs, ... }:
{
  imports = with self.lib.prefixWith "qiront" inputs.self.modules.homeManager; [
    profile-base
    profile-desktop
    profile-personal
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

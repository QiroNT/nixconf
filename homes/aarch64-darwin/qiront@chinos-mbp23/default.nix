_: {
  home.stateVersion = "24.05";

  chinos = {
    suites = {
      common.enable = true;
      personal.enable = true;
    };
  };

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

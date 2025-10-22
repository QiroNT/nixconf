{ ... }:
{
  flake.modules.homeManager.qiront-zellij =
    { ... }:
    {
      programs.zellij = {
        enable = true;
        settings = {
          on_force_close = "quit";
        };
      };
    };
}

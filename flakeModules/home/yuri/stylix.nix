{ inputs, ... }:
{
  flake.modules.homeManager.yuri-stylix =
    { ... }:
    {
      stylix = {
        base16Scheme = "${inputs.tt-schemes}/base16/monokai.yaml";
        targets.vscode.enable = false;
      };
    };
}

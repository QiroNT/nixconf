{ ... }:
{
  flake.lib.hasAny = config: name: builtins.elem name config.chinos.any.activeModules;
}

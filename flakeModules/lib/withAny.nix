{ config, ... }:
{
  flake.lib.withAny = class: config.flake.modules.${class};
}

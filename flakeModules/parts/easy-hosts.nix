{ inputs, ... }:
{
  imports = [ inputs.easy-hosts.flakeModule ];

  easy-hosts = {
    autoConstruct = true;
    path = builtins.path { path = ../..; } + "/hosts";

    perClass = class: {
      specialArgs = {
        inherit class;
      };
    };
  };
}

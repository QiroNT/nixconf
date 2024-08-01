{
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  home.stateVersion = "24.05";

  chinos = {
    suites = {
      common.enable = true;
    };
  };
}

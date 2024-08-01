{
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  # this doesn't need to be touched,
  # touching it will definitely break things, so beware
  system.stateVersion = "24.05";

  # since we're building images, this needs to be specified
  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.hostPlatform.system = "aarch64-linux";
  nixpkgs.buildPlatform.system = "x86_64-linux";

  chinos = {
    suites = {
      common.enable = true;
    };
  };
}

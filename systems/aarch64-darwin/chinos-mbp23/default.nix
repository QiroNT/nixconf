{
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  # used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # nix-darwin doesn't have a hardware config so..
  nixpkgs.hostPlatform = "aarch64-darwin";

  chinos = {
    suites = {
      common.enable = true;
    };
  };
}

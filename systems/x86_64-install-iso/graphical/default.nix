{ lib, pkgs, ... }:
{
  # i think this should be updated when nixos-unstable points to a new version
  # since it's a "fresh install"
  system.stateVersion = "24.11";

  # `install-iso` adds wireless support that
  # is incompatible with networkmanager.
  networking.wireless.enable = lib.mkForce false;

  users.users.qiront.password = "";

  chinos = {
    kernel-latest.enable = false;
    wireless.enable = true;
    suites = {
      common.enable = true;
      desktop.enable = true;
    };
  };
}

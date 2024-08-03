{ lib, pkgs, ... }:
{
  # i think this should be updated when nixos-unstable points to a new version
  # since it's a "fresh install"
  system.stateVersion = "24.11";

  # `install-iso` adds wireless support that
  # is incompatible with networkmanager.
  networking.wireless.enable = lib.mkForce false;

  chinos = {
    grub.enable = false;
    kernel-latest.enable = false;
    wireless.enable = true;
    suites = {
      common.enable = true;
    };
  };
}

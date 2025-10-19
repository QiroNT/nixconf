{ lib, inputs, ... }:
{
  imports = with inputs.self.modules.nixos; [
    profilePersonal

    users-qiront

    kernel-latest
    wireless
  ];

  # i think this should be updated when nixos-unstable points to a new version
  # since it's a "fresh install"
  system.stateVersion = "24.11";

  # `install-iso` adds wireless support that
  # is incompatible with networkmanager.
  networking.wireless.enable = lib.mkForce false;

  users.users.qiront.password = "";

  home-manager.users.qiront = import ./homes/qiront.nix;
}

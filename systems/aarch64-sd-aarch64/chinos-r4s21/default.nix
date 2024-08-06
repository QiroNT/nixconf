{ lib, modulesPath, ... }:
{
  imports = [ ./hardware.nix ];

  # i think this should be updated when nixos-unstable points to a new version
  # since it's a "fresh install"
  system.stateVersion = "24.11";

  # Enable OpenSSH
  services.sshd.enable = true;

  # root autologin etc
  users.users.root.password = "root";
  services.openssh.permitRootLogin = lib.mkDefault "yes";
  services.getty.autologinUser = lib.mkDefault "root";

  chinos = {
    kernel-latest.enable = false;
    suites = {
      common.enable = true;
    };
  };
}

{ lib, ... }:
{
  flake.modules.generic.docker =
    { class, pkgs, ... }:
    lib.optionalAttrs (class == "nixos") {
      users.users.qiront.extraGroups = [ "docker" ];
      virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
      };
    };
}

{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.suites.personal;
in
{
  options.${namespace}.suites.personal = with lib.types; {
    enable = lib.mkEnableOption "the personal suite";
  };

  config = lib.mkIf cfg.enable {
    chinos = {
      sops.enable = true;
      kernel-latest.enable = lib.mkDefault true;
    };

    # SUID wrapper, not sure if i need this, but just to not bother my future self
    programs.mtr.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # compatibility
    programs.nix-ld = {
      enable = true;
      # Add any missing dynamic libraries for unpackaged programs
      # here, NOT in environment.systemPackages
      libraries = with pkgs; [ ];
    };

    # the program that i have to use to do any work
    users.users.qiront.extraGroups = [ "docker" ];
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
    };

    # private npm registry
    sops.secrets."personal/npm/npmrc" = {
      sopsFile = ../../../../secrets/personal.yaml;
      path = "/home/qiront/.npmrc";
      owner = "qiront";
    };
  };
}

{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.docker;
in
{
  options.${namespace}.docker = with lib.types; {
    enable = lib.mkEnableOption "docker";
  };

  config = lib.mkIf cfg.enable {
    users.users.qiront.extraGroups = [ "docker" ];
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
    };
  };
}

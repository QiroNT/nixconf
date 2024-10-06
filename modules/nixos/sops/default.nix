{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.sops;
in
{
  options.${namespace}.sops = with lib.types; {
    enable = lib.mkEnableOption "sops";
  };

  config = lib.mkIf cfg.enable {
    sops = {
      defaultSopsFile = ../../../secrets/common.yaml;
      age.keyFile = "/var/lib/sops-nix/keys.txt";
    };
  };
}

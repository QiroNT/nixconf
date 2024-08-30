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
      # $ sudo mkdir -p /var/lib/sops-nix
      # $ sudo age-keygen -o /var/lib/sops-nix/key.txt
      age.keyFile = "/var/lib/sops-nix/key.txt";
    };
  };
}

{
  lib,
  namespace,
  inputs,
  config,
  ...
}:
let
  cfg = config.${namespace}.services.satisfactory;
in
{
  options.${namespace}.services.satisfactory = with lib.types; {
    enable = lib.mkEnableOption "satisfactory";
  };

  config = lib.mkIf cfg.enable {
    containers.satisfactory = {
      autoStart = true;

      privateNetwork = true;
      hostAddress = "192.168.100.1";
      localAddress = "192.168.100.4";
      hostAddress6 = "fc00::1";
      localAddress6 = "fc00::4";

      config = containerInputs: {
        imports = [ inputs.satisfactory-server-flake.nixosModules.satisfactory ];

        nixpkgs.config.allowUnfree = true;

        services.satisfactory = {
          enable = true;
          openFirewall = true;
        };

        networking = {
          firewall.enable = true;
          # https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };
        services.resolved.enable = true;

        system.stateVersion = "24.05";
      };
    };
  };
}

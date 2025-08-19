{ lib, ... }:
{
  flake.modules.generic.monerod =
    { class, pkgs, ... }:
    lib.optionalAttrs (class == "nixos") {
      services.monero = {
        enable = true;
        limits = {
          download = 7500;
          upload = 1250;
        };
        extraConfig = ''
          no-igd=1
          hide-my-port=1
          rpc-restricted-bind-ip=0.0.0.0
          rpc-restricted-bind-port=18089
        '';
      };

      networking.firewall.allowedTCPPorts = [ 18089 ];
    };
}

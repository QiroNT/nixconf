{
  inputs,
  self,
  lib,
  ...
}:
{
  flake.modules = self.lib.mkAnyNixos "satisfactory" (
    { ... }:
    {
      containers.satisfactory = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "192.168.100.1";
        localAddress = "192.168.100.4";
        hostAddress6 = "fc00::1";
        localAddress6 = "fc00::4";

        forwardPorts = [
          {
            protocol = "tcp";
            hostPort = 7777;
            containerPort = 7777;
          }
          {
            protocol = "udp";
            hostPort = 7777;
            containerPort = 7777;
          }
        ];

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
    }
  );
}

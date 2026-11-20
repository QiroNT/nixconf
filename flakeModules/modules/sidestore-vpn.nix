{ self, ... }:
{
  flake.modules = self.lib.mkAnyNixos "sidestore-vpn" (
    { lib, pkgs, ... }:
    {
      systemd.services.sidestore-vpn = {
        description = "SideStore VPN";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = "3";
          ExecStart = "${lib.getExe pkgs.nur.repos.xddxdd.sidestore-vpn}";

          AmbientCapabilities = [ "CAP_NET_ADMIN" ];
          CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
          DynamicUser = true;
        };
      };
    }
  );
}

{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "sidestore-vpn" (
    { class, pkgs, ... }:
    lib.optionalAttrs (class == "nixos") {
      systemd.services.sidestore-vpn = {
        description = "SideStore VPN";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = "3";
          ExecStart = "${pkgs.nur.repos.xddxdd.sidestore-vpn}/bin/sidestore-vpn";

          AmbientCapabilities = [ "CAP_NET_ADMIN" ];
          CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
          DynamicUser = true;
        };
      };
    }
  );
}

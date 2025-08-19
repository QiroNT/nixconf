{ lib, ... }:
{
  flake.modules.generic.wireless =
    { class, pkgs, ... }:
    lib.optionalAttrs (class == "nixos") {
      networking = {
        # Received error during CMD_TRIGGER_SCAN: Operation not supported (95)
        # Received Deauthentication event, reason: 4, from_ap: false
        # https://bugzilla.kernel.org/show_bug.cgi?id=203709#c94
        networkmanager.wifi.powersave = false;
      };
    };
}

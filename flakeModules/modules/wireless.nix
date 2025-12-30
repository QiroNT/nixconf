{ self, ... }:
{
  flake.modules = self.lib.mkAnyNixos "wireless" (
    { ... }:
    {
      networking.networkmanager.wifi = {
        # wpa_supplicant has a 200 BSSID limit (see bss_max_count)
        backend = "iwd";
        # Received error during CMD_TRIGGER_SCAN: Operation not supported (95)
        # Received Deauthentication event, reason: 4, from_ap: false
        # https://bugzilla.kernel.org/show_bug.cgi?id=203709#c94
        powersave = false;
      };
    }
  );
}

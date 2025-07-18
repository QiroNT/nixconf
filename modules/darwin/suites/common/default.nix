{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.suites.common;
in
{
  options.${namespace}.suites.common = with lib.types; {
    enable = lib.mkEnableOption "the common suite";
  };

  config = lib.mkIf cfg.enable {
    # TODO move this to home manager once they support it
    system.defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true; # show all file extensions
      };

      CustomUserPreferences = {
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = false;
          ShowHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = false;
          ShowRemovableMediaOnDesktop = false;
        };
        "com.apple.desktopservices" = {
          # avoid creating .DS_Store files on network or usb volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false; # why not
        };
        "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
        "com.apple.ImageCapture".disableHotPlug = true;
      };
    };

    security.pam.services.sudo_local.touchIdAuth = true;

    # TODO remove this upon removing system.defaults
    system.primaryUser = "qiront";

    nix.gc = {
      automatic = true;
      interval = {
        Day = 1;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    homebrew = {
      enable = true;
      user = "qiront";
      # software that can't update itself.
      # giving the ablitity to self update is usually more efficient,
      # tho some software is not able to do so.
      brews = [
        "pinentry-mac"
      ];
      casks = [
        "android-platform-tools" # adb stuff, tho it doesn't bind to path, probably'll do it later
        "battery"
        "calibre"
        "eloston-chromium"
        "google-chrome" # keystone sucks
        "gpgfrontend"
        "iina" # video player, tho i usually use vlc
        "powershell"
      ];

    };
  };
}

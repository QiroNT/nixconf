{...}: {
  imports = [
    ../shared/configuration.nix
  ];

  # used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system = {
    stateVersion = 4;

    defaults = {
      LaunchServices = {
        LSQuarantine = false; # disable "this file was downloaded from the internet" warning
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
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
  };

  security.pam.enableSudoTouchIdAuth = true;

  nix = {
    gc = {
      user = "root";
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
  };

  homebrew = {
    enable = true;
    # software that can't update itself.
    # giving the ablitity to self update is usually more efficient,
    # tho some software is not able to do so.
    casks = [
      "android-platform-tools" # adb stuff, tho it doesn't bind to path, probably'll do it later
      "eloston-chromium"
      "iina" # video player, tho i usually use vlc
      "powershell"
    ];
  };
}

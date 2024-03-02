{...}: {
  imports = [
    ../shared/configuration.nix
  ];

  # used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

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

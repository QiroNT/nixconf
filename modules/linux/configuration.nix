{pkgs, ...}: {
  imports = [
    ../shared/configuration.nix
  ];

  nix.settings = {
    substituters = [
      "https://numtide.cachix.org"
      "https://cache.garnix.io"
    ];
    trusted-public-keys = [
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
  ];

  networking.networkmanager.enable = true; # used to use that too

  security.sudo.wheelNeedsPassword = false; # disable sudo password

  security.polkit = {
    enable = true;
    extraConfig = ''
      // Original rules: https://github.com/coldfix/udiskie/wiki/Permissions
      // Changes: Added org.freedesktop.udisks2.filesystem-mount-system, as this is used by Dolphin.
      polkit.addRule(function(action, subject) {
        var YES = polkit.Result.YES;
        // NOTE: there must be a comma at the end of each line except for the last:
        var permission = {
          // required for udisks1:
          "org.freedesktop.udisks.filesystem-mount": YES,
          "org.freedesktop.udisks.luks-unlock": YES,
          "org.freedesktop.udisks.drive-eject": YES,
          "org.freedesktop.udisks.drive-detach": YES,
          // required for udisks2:
          "org.freedesktop.udisks2.filesystem-mount": YES,
          "org.freedesktop.udisks2.encrypted-unlock": YES,
          "org.freedesktop.udisks2.eject-media": YES,
          "org.freedesktop.udisks2.power-off-drive": YES,
          // Dolphin specific
          "org.freedesktop.udisks2.filesystem-mount-system": YES,
          // required for udisks2 if using udiskie from another seat (e.g. systemd):
          "org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
          "org.freedesktop.udisks2.filesystem-unmount-others": YES,
          "org.freedesktop.udisks2.encrypted-unlock-other-seat": YES,
          "org.freedesktop.udisks2.eject-media-other-seat": YES,
          "org.freedesktop.udisks2.power-off-drive-other-seat": YES
        };
        if (subject.isInGroup("storage")) {
          return permission[action.id];
        }
      });
    '';
  };

  nix = {
    gc = {
      automatic = true;
      persistent = true;
      dates = "0/2:0"; # expands to "*-*-* 00/02:00:00"
      randomizedDelaySec = "45min";
      options = "--delete-older-than 30d";
    };
  };

  users.defaultUserShell = pkgs.zsh;

  # dekstop environment
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  # printing
  services.printing.enable = true;

  # SUID wrapper, not sure if i need this, but just to not bother my future self
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # the app that maximizes my retention
  programs.steam.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # the program that i have to use to do any work
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };
}

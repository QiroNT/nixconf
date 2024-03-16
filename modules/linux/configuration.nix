{pkgs, ...}: {
  imports = [
    ../shared/configuration.nix
  ];

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

  # sddm for login
  services.xserver.enable = true; # still needs to install an xserver dispite i'll never use it
  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      General = {
        DisplayServer = "wayland";
        HaltCommand = "/usr/bin/systemctl poweroff";
        RebootCommand = "/usr/bin/systemctl reboot";
        Numlock = "on";
      };
    };
  };

  # fancy stuff
  programs.hyprland.enable = true;

  # use CUPS for printing
  services.printing.enable = true;

  # enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # SUID wrapper, not sure if i need this, but just to not bother my future self
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # the way to mount disks
  services.udisks2.enable = true;
}

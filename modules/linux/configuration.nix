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
}

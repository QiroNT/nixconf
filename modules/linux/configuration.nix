{
  pkgs,
  ...
}: {
  imports = [
    ../shared/configuration.nix
  ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true; # used to use that too
  # networking.firewall.enable = false;

  security.sudo.wheelNeedsPassword = false; # disable sudo password

  nix.gc = {
    automatic = true;
    persistent = true;
    dates = "0/2:0"; # expands to "*-*-* 00/02:00:00"
    randomizedDelaySec = "45min";
    options = "--delete-older-than 30d";
  };

  users.defaultUserShell = pkgs.zsh;

  # dekstop environment
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-rime
        kdePackages.fcitx5-configtool
      ];
    };
  };

  # sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # printing
  services.printing.enable = true;

  # SUID wrapper, not sure if i need this, but just to not bother my future self
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # compatibility
  programs.nix-ld = {
    enable = true;
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    libraries = with pkgs; [
    ];
  };

  # the app that maximizes my retention
  programs.steam.enable = true;
  hardware.graphics.enable32Bit = true;

  # controller
  hardware.xone.enable = true;
  hardware.xpadneo.enable = true;

  # the program that i have to use to do any work
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };
}

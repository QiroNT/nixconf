{pkgs, ...}: {
  imports = [
    ../shared/configuration.nix
  ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
        useOSProber = true;
      };
    };
  };

  networking.networkmanager.enable = true; # used to use that too

  # networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [];
  networking.firewall.allowedUDPPorts = [];

  nix.gc = {
    automatic = true;
    persistent = true;
    dates = "monthly";
    randomizedDelaySec = "45min";
    options = "--delete-older-than 30d";
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.qiront = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # for sudo
        "docker"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvmbrlQOuijlg3nk4YeoFZQKmoXSJVcjlrQR6Vzvhlk171irIx0ItbfpL29BsyssHCU6RMSYd57qMP27SqU5FF1txHJ0+p2UTHZrKpaXxBM9pQ6FJpKt3mqiNbHnNs4gNfXnqK+XBnyzgZnMe1oOa3+1LSpHDlcOGM9ncyTU9RURTbNLmKpQHBCdu/AWSbaS2CfnL2fHvK0Sf38bGs/eBV3Ck0w3mKZ2vcRqw1IDAex7I7H27+4CNiJ+St8S4jBMsH4EVw+PW+KJaxBV4FtM3HtDM3YW3zARg/SqKiOTAW5IzyHaoHUx3lquvqUFV/+OaAJgnF9k8thnx68yOSd6I3LR7B2+ttQ3f1sgRLSdZMm8X3dpfYA5pg4CHO4uRevC2tDuPl0MzBXWyUbXqjiy7mNX1N8etljbhCaWY5selexiWCWqswjahW97p5lVasZRlKff2mZ6LFgnSTzjWQ5vO2k4OfvVQLQ7p9IvXv74+lIRL+6AR2jfZJHPUncYQ0/r/k1f36qF3l7IQFl6zHHIEZDllPOLM7otZ5Sb5p4Eo7vwEwSzQ7YhmwRuZ0mWQ+xW+2ZcNLsqXIsfjkItrCp0WkPU6SihvkvOKrp3zcBDMguj2IQUa66HMzQQkEWui7ghvycL7Q7FlRjs7di7RWmv5QbEfhxC3jPTmSx9JdvyNhMQ== qiront@qiront-desktop-manjaro-kde"
      ];
    };
  };

  # desktop environment
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  # i actually only use this for clipboard sync
  programs.kdeconnect.enable = true;

  fonts.fontDir.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-rime
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

  # ssh
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      # PermitRootLogin = "yes";
    };
  };

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

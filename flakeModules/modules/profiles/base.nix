{ lib, config, ... }:
{
  flake.modules.generic.profileBase =
    { class, pkgs, ... }:
    {
      imports = [
        {
          imports = with config.flake.modules.generic; [
            home-manager
            nix
            nixpkgs
            sops
          ];

          # create /etc/zshrc that loads the environment
          programs.zsh.enable = true;

          sops.secrets."common/nix/netrc" = {
            sopsFile = ../../../secrets/common.yaml;
          };
        }

        (lib.optionalAttrs (class == "nixos") {
          # packages installed in system profile. to search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs; [
            sbctl # debug secure boot
          ];

          boot.loader = {
            efi.canTouchEfiVariables = true;
            systemd-boot.enable = true;
          };

          # firmware updates
          services.fwupd.enable = true;

          services.btrfs.autoScrub = {
            enable = true;
            interval = "weekly";
            fileSystems = [ "/" ];
          };

          networking.networkmanager.enable = true; # used to use that too

          networking.firewall = {
            # enable = false;
            allowedTCPPorts = [ ];
            allowedUDPPorts = [ ];
          };

          users = {
            defaultUserShell = pkgs.zsh;
            users.qiront = {
              isNormalUser = true;
              extraGroups = [
                "wheel" # for sudo
              ];
              openssh.authorizedKeys.keys = [
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvmbrlQOuijlg3nk4YeoFZQKmoXSJVcjlrQR6Vzvhlk171irIx0ItbfpL29BsyssHCU6RMSYd57qMP27SqU5FF1txHJ0+p2UTHZrKpaXxBM9pQ6FJpKt3mqiNbHnNs4gNfXnqK+XBnyzgZnMe1oOa3+1LSpHDlcOGM9ncyTU9RURTbNLmKpQHBCdu/AWSbaS2CfnL2fHvK0Sf38bGs/eBV3Ck0w3mKZ2vcRqw1IDAex7I7H27+4CNiJ+St8S4jBMsH4EVw+PW+KJaxBV4FtM3HtDM3YW3zARg/SqKiOTAW5IzyHaoHUx3lquvqUFV/+OaAJgnF9k8thnx68yOSd6I3LR7B2+ttQ3f1sgRLSdZMm8X3dpfYA5pg4CHO4uRevC2tDuPl0MzBXWyUbXqjiy7mNX1N8etljbhCaWY5selexiWCWqswjahW97p5lVasZRlKff2mZ6LFgnSTzjWQ5vO2k4OfvVQLQ7p9IvXv74+lIRL+6AR2jfZJHPUncYQ0/r/k1f36qF3l7IQFl6zHHIEZDllPOLM7otZ5Sb5p4Eo7vwEwSzQ7YhmwRuZ0mWQ+xW+2ZcNLsqXIsfjkItrCp0WkPU6SihvkvOKrp3zcBDMguj2IQUa66HMzQQkEWui7ghvycL7Q7FlRjs7di7RWmv5QbEfhxC3jPTmSx9JdvyNhMQ== qiront@qiront-desktop-manjaro-kde"
              ];
            };
          };

          # ssh
          services.openssh = {
            enable = true;
            settings = {
              PasswordAuthentication = false;
              KbdInteractiveAuthentication = false;
              # PermitRootLogin = "yes";
            };
          };
          services.fail2ban = {
            enable = true;
            ignoreIP = [
              "10.0.0.0/8"
              "172.16.0.0/12"
              "192.168.0.0/16"
            ];
          };

          # for debugging
          services.nixseparatedebuginfod.enable = true;

          # i dont have a server for wg so...
          services.tailscale.enable = true;

          services.cloudflare-warp.enable = true;

          # appimage
          programs.appimage = {
            enable = true;
            binfmt = true;
          };
        })

        (lib.optionalAttrs (class == "darwin") {
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
        })
      ];
    };
}

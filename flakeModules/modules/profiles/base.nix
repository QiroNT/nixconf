{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "profile-base" (
    { class, pkgs, ... }:
    {
      imports = [
        {
          imports = with self.lib.withAny class; [
            stylix
            any
            home-manager
            nix
            nixpkgs
            sops
          ];

          # create /etc/zshrc that loads the environment
          programs.zsh.enable = true;
        }

        (lib.optionalAttrs (class == "nixos") {
          # packages installed in system profile. to search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs; [
            sbctl # debug secure boot
          ];

          boot = {
            loader = {
              efi.canTouchEfiVariables = true;
              systemd-boot.enable = true;
            };
            initrd = {
              compressor = "zstd";
              compressorArgs = [
                "-19"
                "-T0"
              ];
              systemd.enable = true;
            };
          };

          # firmware updates
          services.fwupd.enable = true;

          services.btrfs.autoScrub = {
            enable = true;
            interval = "weekly";
            fileSystems = [ "/" ];
          };

          networking.networkmanager.enable = true; # used to use that too

          networking.nftables.enable = true;
          networking.firewall = {
            # enable = false;
            allowedTCPPorts = [ ];
            allowedUDPPorts = [ ];
          };

          users.defaultUserShell = pkgs.zsh;

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
          services.nixseparatedebuginfod2 = {
            enable = true;
            substituters = [
              "local:"
              "https://cache.nixos.org"
              "https://cache.garnix.io"
              "https://nix-community.cachix.org"
              "https://numtide.cachix.org"
              "https://niri.cachix.org"
              "https://attic.xuyh0120.win/lantian"
            ];
          };

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
              "ungoogled-chromium"
              "ghostty"
              "google-chrome" # keystone sucks
              "gpgfrontend"
              "iina" # video player, tho i usually use vlc
              "powershell"
            ];
          };
        })
      ];
    }
  );
}

{ inputs, ... }:
{
  imports = with inputs.self.modules.nixos; [
    profileBase

    docker
    forgejo
    forgejo-actions-runner
    kernel-latest
    # monerod
    # satisfactory
    vaultwarden
    wireless

    ./hardware.nix
    ./wg-quick.nix
    ./cloudflared.nix
  ];

  # this doesn't need to be touched,
  # touching it will definitely break things, so beware
  system.stateVersion = "24.05";

  boot.initrd.kernelModules = [ "amdgpu" ];

  # fix file system options
  fileSystems = {
    "/nix".options = [ "noatime" ];
    "/swap".options = [ "noatime" ];
    "/boot".options = [
      "noatime"
      "errors=remount-ro"
    ];
  };
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = builtins.floor (4.5 * 1024);
    }
  ];

  home-manager.users.qiront = import ./home.nix;

  networking.hostName = "chinos-hlb24"; # first homelab

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = "enp1s0";
  };

  # exit node
  services.tailscale.useRoutingFeatures = "server";
}

{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "forgejo-runner" (
    {
      class,
      pkgs,
      config,
      ...
    }:
    lib.optionalAttrs (class == "nixos") {
      imports = with self.lib.withAny class; [
        sops
      ];

      containers.forgejo-ar = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "192.168.100.1";
        localAddress = "192.168.100.5";
        hostAddress6 = "fc00::1";
        localAddress6 = "fc00::5";

        bindMounts."${config.sops.secrets."chinos-hlb24/forgejo/runner/token".path}".isReadOnly = true;

        config = containerInputs: {
          # note for future me:
          # the runner services requires network to activate and blocks boot,
          # but the networking for the container is only available after boot.
          # until https://github.com/NixOS/nixpkgs/issues/75951
          # or https://github.com/NixOS/nixpkgs/pull/140669 is closed,
          # run the post-start script from the container unit file
          # to manually activate the network
          services.gitea-actions-runner = {
            package = pkgs.forgejo-runner;
            instances.default = {
              enable = true;
              name = "chinos-hlb24";
              url = "https://git.chino.dev";
              tokenFile = config.sops.secrets."chinos-hlb24/forgejo/runner/token".path;
              labels = [
                "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-latest"
                "ubuntu-22.04:docker://ghcr.io/catthehacker/ubuntu:act-22.04"
                "ubuntu-20.04:docker://ghcr.io/catthehacker/ubuntu:act-20.04"
              ];
            };
          };

          virtualisation.docker = {
            enable = true;
            storageDriver = "btrfs";
          };

          systemd.tmpfiles.rules = [
            "z ${config.sops.secrets."chinos-hlb24/forgejo/runner/token".path} 0440 root root - -"
          ];

          networking = {
            firewall.enable = true;
            # https://github.com/NixOS/nixpkgs/issues/162686
            useHostResolvConf = lib.mkForce false;
          };
          services.resolved.enable = true;

          system.stateVersion = "24.05";
        };
      };

      sops.secrets."chinos-hlb24/forgejo/runner/token" = {
        sopsFile = ../../secrets/chinos-hlb24.yaml;
      };
    }
  );
}

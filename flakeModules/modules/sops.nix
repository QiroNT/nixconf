{ ... }:
{
  flake.modules.generic.sops =
    { ... }:
    {
      sops = {
        defaultSopsFile = ../../secrets/common.yaml;
        age.keyFile = "/var/lib/sops-nix/keys.txt";
      };
    };
}

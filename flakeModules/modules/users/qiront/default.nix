{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "users-qiront" (
    { class, ... }:
    {
      imports = [
        {
          imports = with self.lib.prefixWith "users-qiront" (self.lib.withAny class); [
            nix
            docker
          ];
        }

        (lib.optionalAttrs (class == "nixos") {
          users.users.qiront = {
            isNormalUser = true;

            extraGroups = [
              "wheel" # for sudo
            ];

            openssh.authorizedKeys.keys = [
              "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvmbrlQOuijlg3nk4YeoFZQKmoXSJVcjlrQR6Vzvhlk171irIx0ItbfpL29BsyssHCU6RMSYd57qMP27SqU5FF1txHJ0+p2UTHZrKpaXxBM9pQ6FJpKt3mqiNbHnNs4gNfXnqK+XBnyzgZnMe1oOa3+1LSpHDlcOGM9ncyTU9RURTbNLmKpQHBCdu/AWSbaS2CfnL2fHvK0Sf38bGs/eBV3Ck0w3mKZ2vcRqw1IDAex7I7H27+4CNiJ+St8S4jBMsH4EVw+PW+KJaxBV4FtM3HtDM3YW3zARg/SqKiOTAW5IzyHaoHUx3lquvqUFV/+OaAJgnF9k8thnx68yOSd6I3LR7B2+ttQ3f1sgRLSdZMm8X3dpfYA5pg4CHO4uRevC2tDuPl0MzBXWyUbXqjiy7mNX1N8etljbhCaWY5selexiWCWqswjahW97p5lVasZRlKff2mZ6LFgnSTzjWQ5vO2k4OfvVQLQ7p9IvXv74+lIRL+6AR2jfZJHPUncYQ0/r/k1f36qF3l7IQFl6zHHIEZDllPOLM7otZ5Sb5p4Eo7vwEwSzQ7YhmwRuZ0mWQ+xW+2ZcNLsqXIsfjkItrCp0WkPU6SihvkvOKrp3zcBDMguj2IQUa66HMzQQkEWui7ghvycL7Q7FlRjs7di7RWmv5QbEfhxC3jPTmSx9JdvyNhMQ== qiront@qiront-desktop-manjaro-kde"
            ];
          };
        })

        (lib.optionalAttrs (class == "darwin") {

        })
      ];
    }
  );
}

{
  pkgs,
  hostPlatform,
  lib,
  ...
}: {
  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
  ];

  fonts = let
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji

      fira-code
      fira-code-symbols
      monaspace
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "Monaspace"
        ];
      })

      # TODO port ttf-ms-win11-auto
    ];
  in
    {
      fontDir.enable = true;
    }
    // (
      if (lib.strings.hasSuffix "-darwin" hostPlatform)
      then {
        fonts = packages;
      }
      else {
        inherit packages;
      }
    );

  # auto upgrade nix package and the daemon service
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nix;

    settings = {
      # enable flakes support
      experimental-features = "nix-command flakes";
    };
  };

  nixpkgs = {
    inherit hostPlatform;
    config = {
      allowUnfree = true;
    };
  };

  # create /etc/zshrc that loads the environment
  programs.zsh.enable = true;
}

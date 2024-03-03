{
  pkgs,
  hostPlatform,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
in {
  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
  ];

  fonts = let
    packages = with pkgs; [
      open-sans
      noto-fonts
      noto-fonts-emoji
      source-han-sans
      source-han-serif

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
      if isDarwin
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

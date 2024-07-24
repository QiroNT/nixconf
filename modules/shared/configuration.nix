{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;

    settings = {
      # enable flakes support
      experimental-features = "nix-command flakes";

      substituters = [
        "https://numtide.cachix.org"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  fonts.packages = with pkgs; [
    open-sans
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    source-han-sans
    source-han-serif
    geist-font

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

  # create /etc/zshrc that loads the environment
  programs.zsh.enable = true;
}

{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.cli;
in
{
  options.${namespace}.cli = with lib.types; {
    enable = lib.mkEnableOption "cli customizations";
  };

  config = lib.mkIf cfg.enable {
    # i have most things launched via NIX_AUTO_RUN,
    # these are just for quick access
    home.packages = with pkgs; [
      # nix stuff
      nixd # nix language server
      nixfmt-rfc-style
      deadnix
      statix

      # coreutils and alternative
      coreutils-full
      parallel
      gnupg
      fd # better find, why debian uses `fd-find` still bothers me
      jq # i should learn this
      eza # ls
      dua # most convenient disk stuff I've ever used
      ripgrep
      tldr # i can't live without this

      # yep i have 4 monitoring tools for some reason
      btop
      htop
      glances
      inxi

      # great for glancing git while in terminal, not on par with gitlens tho
      gitui

      # fetch
      wget
      curl
      aria # no 2 needed
      yt-dlp

      # sync
      lrzsz
      rsync
      rclone

      # compression
      xz
      zstd
      brotli

      # visual stuff
      ffmpeg-full
      imagemagick
      flac
      libheif
      libwebp
      optipng

      # networking / testing
      iperf
      nmap
      wrk
      oha
    ];

    programs = {
      # zsh is still supported more widely than fish,
      # tho I probably should try fish, maybe later.
      zsh = {
        enable = true;

        # for convenience, like aliases.
        # many plugins have home-manager support, so no need for omz plugin stuff
        oh-my-zsh.enable = true;

        # make it more fish
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
          cat = "bat";
          diff = "difft";
          ls = "eza";
        };
      };

      # use zoxide to replace cd
      zoxide = {
        enable = true;
        options = [ "--cmd cd" ];
      };

      # the cat replacement that actually does something
      bat.enable = true;

      # great file fuzzy finder
      fzf.enable = true;

      # used to use headline, tho kinda slow, so switched to starship
      starship = {
        enable = true;
        # using toml here to benefit from schema & lsp
        settings = builtins.fromTOML (builtins.readFile ./config/starship.toml);
      };

      # zsh history is just too smol
      atuin = {
        enable = true;
        settings = {
          auto_sync = true; # remember to login with `atuin login -u <USERNAME>`
          enter_accept = true;
          filter_mode_shell_up_key_binding = "session";
          style = "compact";
        };
      };

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
  };
}

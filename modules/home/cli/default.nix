{
  lib,
  pkgs,
  namespace,
  config,
  system,
  ...
}:
let
  cfg = config.${namespace}.cli;
in
{
  options.${namespace}.cli = with lib.types; {
    enable = lib.mkEnableOption "cli customizations";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      # i have most things launched via NIX_AUTO_RUN,
      # these are just for quick access
      home.packages = with pkgs; [
        # coreutils and alternative
        coreutils-full
        parallel
        gnupg
        fd # better find, why debian uses `fd-find` still bothers me
        jq # i should learn this
        eza # ls
        dua # most convenient disk stuff I've ever used
        ripgrep
        ast-grep
        tldr # i can't live without this

        # yep i have 4 monitoring tools for some reason
        btop
        htop
        glances
        inxi

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
          # zprof.enable = true;

          # for convenience, like aliases.
          # many plugins have home-manager support, so no need for omz plugin stuff
          oh-my-zsh = {
            enable = true;
            extraConfig = ''
              zstyle ':omz:update' mode disabled
            '';
          };

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

        # file explorer
        yazi = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
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
    })

    (lib.mkIf (cfg.enable && lib.snowfall.system.is-linux system) {
      home.packages = with pkgs; [
        # cli stuff
        kwalletcli
        rime-cli
        psmisc # killall

        # compression
        p7zip

        # disk stuff
        ifuse # for ios
        mtools # NTFS
        nfs-utils # nfs

        # network
        cloudflared # tunnel
        cloudflare-warp
        tailscale
        inetutils # telnet / ping
      ];

      programs.zsh.initContent = ''
        # pnpm
        export PNPM_HOME="/home/qiront/.local/share/pnpm"
        case ":$PATH:" in
          *":$PNPM_HOME:"*) ;;
          *) export PATH="$PNPM_HOME:$PATH" ;;
        esac
        # pnpm end

        # editor
        if [[ -n $SSH_CONNECTION ]]; then
          export EDITOR='nano'
        else
          export EDITOR='code --new-window --wait'
        fi
        export VISUAL="$EDITOR"
      '';
    })

    (lib.mkIf (cfg.enable && lib.snowfall.system.is-darwin system) {
      programs.zsh.initContent = ''
        # pnpm
        export PNPM_HOME="/Users/qiront/Library/pnpm"
        case ":$PATH:" in
          *":$PNPM_HOME:"*) ;;
          *) export PATH="$PNPM_HOME:$PATH" ;;
        esac
        # pnpm end

        # editor
        if [[ -n $SSH_CONNECTION ]]; then
          export EDITOR='nano'
        else
          export EDITOR='code --new-window --wait'
        fi
        export VISUAL="$EDITOR"
      '';
    })
  ];
}

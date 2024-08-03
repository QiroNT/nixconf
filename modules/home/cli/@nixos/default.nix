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
  config = lib.mkIf (cfg.enable && lib.snowfall.system.is-linux system) {
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

    programs.zsh.initExtra = ''
      # pnpm
      export PNPM_HOME="/home/qiront/.local/share/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac
      # pnpm end
    '';
  };
}

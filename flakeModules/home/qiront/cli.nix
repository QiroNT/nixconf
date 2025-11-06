{ lib, ... }:
{
  flake.modules.homeManager.qiront-cli =
    { class, pkgs, ... }:
    {
      imports = [
        {
          # i have most things launched via comma,
          # these are just for quick access
          home.packages = with pkgs; [
            # yep i have 5 monitoring tools for some reason
            fastfetch
            btop
            htop
            glances
            inxi

            # fetch
            wget
            curl
            aria2
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
        }

        (lib.optionalAttrs (class == "nixos") {
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
        })

        (lib.optionalAttrs (class == "darwin") {
        })
      ];
    };
}

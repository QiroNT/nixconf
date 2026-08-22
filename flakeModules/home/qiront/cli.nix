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

            # archival
            gnutar
            xz
            zstd
            brotli
            _7zz
            asar
            payload-dumper-go
            lz4
            cpio

            # visual stuff
            ffmpeg-full
            imagemagick
            flac
            libheif
            libwebp
            optipng

            # disk
            dua
            e2fsprogs

            # networking
            bind
            mtr
            iperf
            nmap
            miniupnpc
            wrk
            oha

            chafa # image printer
            sops
            vulkan-tools
            watch
            watchexec
          ];
        }

        (lib.optionalAttrs (class == "nixos") {
          home.packages = with pkgs; [
            # cli stuff
            psmisc # killall
            qemu
            rime-cli

            # disk stuff
            btdu
            ifuse # for ios
            mtools # NTFS
            nfs-utils

            # network
            cloudflared # tunnel
            cloudflare-warp
            inetutils # telnet / ping
            nixos-firewall-tool
            tailscale
          ];
        })

        (lib.optionalAttrs (class == "darwin") {
        })
      ];
    };
}

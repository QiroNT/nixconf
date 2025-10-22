{ lib, ... }:
{
  flake.modules.homeManager.qiront-zsh =
    {
      class,
      config,
      pkgs,
      ...
    }:
    {
      imports = [
        {
          home.packages = with pkgs; [
            # coreutils and alternative
            coreutils-full
            parallel
            gnupg
            fd # better find, why debian uses `fd-find` still bothers me
            jq # i should learn this
            eza # ls
            dua
            ripgrep
            ast-grep
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
                update_check = false;
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
        }

        (lib.optionalAttrs (class == "nixos") {
          programs.zsh.initContent = ''
            # pnpm
            export PNPM_HOME="${config.home.homeDirectory}/.local/share/pnpm"
            case ":$PATH:" in
              *":$PNPM_HOME:"*) ;;
              *) export PATH="$PNPM_HOME:$PATH" ;;
            esac
            # pnpm end

            # editor
            export EDITOR="hx"
            export VISUAL="$EDITOR"
          '';
        })

        (lib.optionalAttrs (class == "darwin") {
          programs.zsh.initContent = ''
            # pnpm
            export PNPM_HOME="${config.home.homeDirectory}/Library/pnpm"
            case ":$PATH:" in
              *":$PNPM_HOME:"*) ;;
              *) export PATH="$PNPM_HOME:$PATH" ;;
            esac
            # pnpm end

            # editor
            export EDITOR="hx"
            export VISUAL="$EDITOR"
          '';
        })
      ];
    };
}

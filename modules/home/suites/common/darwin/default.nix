{
  lib,
  namespace,
  config,
  system,
  ...
}: let
  cfg = config.${namespace}.suites.common;
in {
  config = lib.mkIf (cfg.enable && lib.snowfall.system.is-darwin system) {
    programs = {
      # conda and pnpm paths
      # conda is manually installed, i know nix community hates conda,
      # tho given my willingness of dealing with python deps after the constant
      # torture of javascript, i decided that i just don't care anymore
      zsh.initExtra = ''
        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
        __conda_setup="$('/Users/qiront/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "/Users/qiront/opt/anaconda3/etc/profile.d/conda.sh" ]; then
                . "/Users/qiront/opt/anaconda3/etc/profile.d/conda.sh"
            else
                export PATH="/Users/qiront/opt/anaconda3/bin:$PATH"
            fi
        fi
        unset __conda_setup
        # <<< conda initialize <<<

        # pnpm
        export PNPM_HOME="/Users/qiront/Library/pnpm"
        case ":$PATH:" in
          *":$PNPM_HOME:"*) ;;
          *) export PATH="$PNPM_HOME:$PATH" ;;
        esac
        # pnpm end
      '';
    };
  };
}

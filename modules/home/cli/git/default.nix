{
  lib,
  pkgs,
  namespace,
  config,
  system,
  ...
}:
let
  cfg = config.${namespace}.cli.git;
in
{
  options.${namespace}.cli.git = with lib.types; {
    enable = lib.mkEnableOption "git and related tools";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        # great for glancing git while in terminal, not on par with gitlens tho
        gitui
      ];

      programs = {
        # the software people used to convince everyone else to use
        git = {
          enable = true;
          package = pkgs.git.override {
            sendEmailSupport = true;
            withSsh = true;
            withLibsecret = !lib.snowfall.system.is-darwin system;
          };
          lfs.enable = true;

          # idk what im missing out before
          difftastic.enable = true;

          userName = "Chino Moka";
          userEmail = "i@chino.dev";
          extraConfig = {
            # main good
            init.defaultBranch = "main";

            # should be default
            diff.algorithm = "histogram";

            # why merge when you can stash & rebase
            pull.rebase = "true";

            # let git resolve conflicts for you
            rerere.enabled = "true";

            # the one git command that have nothing to do with git
            # (this options makes branches display in grid, much better experience)
            column.ui = "auto";

            # actually, vscode does this by default and it's much better,
            # should set this in cli too
            branch.sort = "-committerdate";

            # i still left wondering how on earth would i configure repo maintenance

            # tutorial: https://git-send-email.io/
            # auth with $ git config --global sendemail.smtpPass 'app password'
            sendemail = {
              smtpserver = "shadow.mxrouting.net";
              smtpserverport = "465";
              smtpencryption = "ssl";
              smtpuser = "i@chino.dev";
            };
          };
        };

        # the thing i use to auth the thing just above
        gh.enable = true; # ok it's github cli
      };
    })

    (lib.mkIf (cfg.enable && lib.snowfall.system.is-linux system) {
      # for git credentials
      home.packages = with pkgs; [ libsecret ];
      programs.git.extraConfig = {
        credential.helper = "/etc/profiles/per-user/$(whoami)/bin/git-credential-libsecret";
      };
    })
  ];
}

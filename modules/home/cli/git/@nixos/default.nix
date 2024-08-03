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
  config = lib.mkIf (cfg.enable && lib.snowfall.system.is-linux system) {
    # for git credentials
    home.packages = with pkgs; [ libsecret ];
    programs.git.extraConfig = {
      credential.helper = "/etc/profiles/per-user/$(whoami)/bin/git-credential-libsecret";
    };
  };
}

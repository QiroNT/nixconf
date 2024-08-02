{
  lib,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.cli.nix-index;
in {
  options.${namespace}.cli.nix-index = with lib.types; {
    enable = lib.mkEnableOption "nix-index and command-not-found";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      nix-index.enable = true; # command-not-found
      nix-index-database.comma.enable = true; # , -> nix run nixpkgs#
    };
    home.sessionVariables = {
      NIX_AUTO_RUN = "1";
    };
  };
}

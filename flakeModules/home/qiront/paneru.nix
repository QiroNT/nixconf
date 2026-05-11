{ lib, ... }:
{
  flake.modules.homeManager.qiront-paneru =
    { inputs, class, ... }:
    lib.optionalAttrs (class == "darwin") {
      imports = [
        inputs.paneru.homeModules.paneru
      ];

      services.paneru.enable = true;
    };
}

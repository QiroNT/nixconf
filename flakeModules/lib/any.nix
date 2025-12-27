{ lib, config, ... }:
let
  buildModule = name: module: {
    ${name}.imports = [
      { chinos.any.activeModules = [ name ]; }
      module
    ];
  };
in
{
  flake.lib.mkAny = name: module: {
    nixos = buildModule name module;
    darwin = buildModule name module;
  };

  flake.lib.mkAnyNixos = name: module: {
    nixos = buildModule name module;
    darwin = buildModule name { };
  };

  flake.lib.mkAnyDarwin = name: module: {
    nixos = buildModule name { };
    darwin = buildModule name module;
  };

  flake.lib.mkAnyMatch =
    name: module:
    let
      apply = args: f: if builtins.isFunction f then f args else f;
      mapReturn =
        keys: args:
        let
          output = apply args module;
        in
        {
          imports = keys |> map (key: output.${key} or { });
        };
      wrap = keys: lib.setFunctionArgs (mapReturn keys) (lib.functionArgs module);
    in
    {
      nixos = buildModule name (wrap [
        "any"
        "nixos"
      ]);
      darwin = buildModule name (wrap [
        "any"
        "darwin"
      ]);
    };

  flake.lib.withAny = class: config.flake.modules.${class};

  flake.lib.hasAny = config: name: builtins.elem name config.chinos.any.activeModules;

  # { p-a = 1; p-b = 2} ==> { a = 1; b = 2 }
  flake.lib.prefixWith =
    prefix: attrs:
    attrs
    |> lib.filterAttrs (name: _: lib.hasPrefix (prefix + "-") name)
    |> lib.mapAttrs' (name: value: lib.nameValuePair (lib.removePrefix (prefix + "-") name) value);
}

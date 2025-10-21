{ lib, ... }:
{
  # { p-a = 1; p-b = 2} ==> { a = 1; b = 2 }
  flake.lib.prefixWith =
    prefix: attrs:
    attrs
    |> lib.filterAttrs (name: _: lib.hasPrefix (prefix + "-") name)
    |> lib.mapAttrs' (name: value: lib.nameValuePair (lib.removePrefix (prefix + "-") name) value);
}

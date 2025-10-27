{ inputs, lib, ... }:
{
  flake.lib.infuse = (import (inputs.infuse + "/default.nix") { inherit lib; }).v1.infuse;
}

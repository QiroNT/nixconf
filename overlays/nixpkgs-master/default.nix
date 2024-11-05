{ channels, ... }:
final: prev: {
  inherit (channels.nixpkgs-master) factorio-headless;
}

{ self, ... }:
{
  flake.modules = self.lib.mkAny "nixpkgs" (
    { nixpkgsArgs, ... }:
    {
      nixpkgs = nixpkgsArgs;
    }
  );
}

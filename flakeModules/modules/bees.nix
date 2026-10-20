{ self, ... }:
{
  flake.modules = self.lib.mkAnyNixos "bees" (
    { ... }:
    {
      services.beesd.filesystems.root = {
        spec = "/";
        # 128m/tb x2-4 compressed
        hashTableSizeMB = 1024;
        extraOptions = [
          "--thread-factor"
          "0.5"
        ];
      };
    }
  );
}

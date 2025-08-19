{ lib, ... }:
{
  flake.modules.generic.postgresql =
    { class, pkgs, ... }:
    lib.optionalAttrs (class == "nixos") {
      services.postgresql = {
        enable = true;
        enableJIT = true;
        enableTCPIP = true;
        package = pkgs.postgresql_17;
        settings = {
          max_connections = 200;
          shared_buffers = "2GB";
          maintenance_work_mem = "512MB";
          wal_buffers = "16MB";
          random_page_cost = 1.1;
          effective_io_concurrency = 200;
          work_mem = "10082kB";
          huge_pages = "off";
          min_wal_size = "1GB";
          max_wal_size = "4GB";
          max_worker_processes = 8;
          max_parallel_workers = 8;
          max_parallel_workers_per_gather = 4;
          max_parallel_maintenance_workers = 4;
        };
      };
    };
}

{
  buildGo126Module,
  fetchFromGitHub,
  ...
}:
let
  buildExec =
    exec: vendorHash:
    buildGo126Module rec {
      pname = "certdx-${exec}";
      version = "0.5.0";

      src = fetchFromGitHub {
        owner = "ParaParty";
        repo = "certdx";
        rev = "v${version}";
        sha256 = "sha256-JTeL9P1kFKMtiauHSxyfIg/C/aO6M6jgz2MkXq9B2tQ=";
      };

      env = {
        CGO_ENABLED = 0;
        GOWORK = "off";
      };

      ldflags = [
        "-s"
        "-w"
        "-X main.buildTag=v${version}"
        "-X main.buildDate=1970-01-01T00:00:00Z"
      ];

      modRoot = "./exec/${exec}";
      subPackages = [ "." ];
      inherit vendorHash;

      postInstall = ''
        mv $out/bin/${exec} $out/bin/certdx-${exec};
      '';
    };
in
{
  client = buildExec "client" "sha256-vrvVDIuYsZq21KAQJ3FqSWILs3ocTd531+p6CoG9Pec=";
  server = buildExec "server" "sha256-pzRinrFGU7wtWHHU2Kz4t7GCPeGT6TCwvQKwAMy8vZw=";
  tools = buildExec "tools" "sha256-C7iHzZCsnVQVDQ2nTpQlXUrzvR0PjrSSBBtyz0wQ+Ns=";
}

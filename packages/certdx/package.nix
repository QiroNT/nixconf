{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  ...
}:
let
  buildExec =
    exec: vendorHash:
    buildGo125Module rec {
      pname = "certdx-${exec}";
      version = "0.4.5";

      src = fetchFromGitHub {
        owner = "ParaParty";
        repo = "certdx";
        rev = "v${version}";
        sha256 = "sha256-NXZJFWLMFv9qUqQaqLgj11iUMaoZg+fTp9Mpzgtxgu4=";
      };

      ldflags = [
        "-s"
        "-w"
        "-X main.buildCommit=${src.rev}"
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
  client = buildExec "client" "sha256-7ZwiPbSCKZr6BMXWFA14LJhCbVa1LOQr0hz2VYSpjCM=";
  server = buildExec "server" "sha256-vni/u3cBqdJNSSy5+N9SyWJrM5dyxLHnCOkZahEtIn0=";
  tools = buildExec "tools" "sha256-6yqmOldQCbUh9Kt56nY43p1kPbWhmjkyZgAq8MeXaws=";
}

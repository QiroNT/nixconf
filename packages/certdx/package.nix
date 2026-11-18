{
  buildGo127Module,
  fetchFromGitHub,
  ...
}:
let
  buildExec =
    exec: vendorHash:
    buildGo127Module rec {
      pname = "certdx-${exec}";
      version = "0.9.1";

      src = fetchFromGitHub {
        owner = "ParaParty";
        repo = "certdx";
        rev = "v${version}";
        sha256 = "sha256-Fpn4cFaklm1ruuaw/JrufYYahXozAf0LyqDfNMSNT7Q=";
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
  client = buildExec "client" "sha256-qI4Ops7lBIzDT68vTalhbatvSa+ZR2cDcU/pCcdM8Ws=";
  server = buildExec "server" "sha256-u7C1uGiL0RgjkjeS76kZ7i0fIDkPHQjawp+Cnj/1+/s=";
  tools = buildExec "tools" "sha256-7CVVoVQmzNiZ9AV2cma3+7SCxMyiYJFMJdNIkED4Pgc=";
}

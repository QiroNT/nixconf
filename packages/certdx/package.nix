{
  buildGo124Module,
  fetchFromGitHub,
  ...
}:
let
  buildExec =
    exec: vendorHash:
    buildGo124Module rec {
      pname = "certdx-${exec}";
      version = "0.4.2";

      src = fetchFromGitHub {
        owner = "ParaParty";
        repo = "certdx";
        rev = "v${version}";
        sha256 = "sha256-hy/6cG5wcOy1tpEYBj7U7NfIxYHT2cUZkXDCPoXySQU=";
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
  client = buildExec "client" "sha256-548mU6ygjOtZaipE1R1HBY/uxyug5GoapXFhhyQhi4Y=";
  server = buildExec "server" "sha256-JyONEdGh6bF5Ts1XcRljLoEECfE1em9lEQncmh/nb+0=";
  tools = buildExec "tools" "sha256-VLBtzSY822D7oDO3REuVlr4ERsEKFI9GWlzpLDmgOb0=";
}

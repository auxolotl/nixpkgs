{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nezha-agent,
  testers,
}:
buildGoModule rec {
  pname = "nezha-agent";
  version = "0.16.6";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "agent";
    rev = "v${version}";
    hash = "sha256-+78WrkFMY2dfqU3ShmzQgR1ZgEKyb9COUjlIf695OM8=";
  };

  vendorHash = "sha256-kqu3+hO0juxI5qbczVFg0GF+pljmePFbKd59a14U7Pg=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # The test failed due to a geoip request in the sandbox. Remove it to avoid network requirement
  preCheck = ''
    rm ./pkg/monitor/myip_test.go
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = nezha-agent;
      command = "${nezha-agent}/bin/agent -v";
    };
  };

  meta = with lib; {
    description = "Agent of Nezha Monitoring";
    homepage = "https://github.com/nezhahq/agent";
    license = licenses.asl20;
    maintainers = with maintainers; [ moraxyc ];
  };
}

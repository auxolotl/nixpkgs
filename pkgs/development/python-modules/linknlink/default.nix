{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "linknlink";
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "xuanxuan000";
    repo = "python-linknlink";
    rev = "refs/tags/${version}";
    hash = "sha256-G0URNUHIh/td+A8MhIC0mePx2SmhEXhIzOpbVft33+w=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cryptography
  ];

  pythonImportsCheck = [
    "linknlink"
  ];

  # Module has no test
  doCheck = false;

  meta = with lib; {
    description = "Module and CLI for controlling Linklink devices locally";
    homepage = "https://github.com/xuanxuan000/python-linknlink";
    changelog = "https://github.com/xuanxuan000/python-linknlink/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

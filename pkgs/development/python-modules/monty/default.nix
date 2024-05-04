{ lib
, buildPythonPackage
, fetchFromGitHub
, msgpack
, numpy
, pandas
, pydantic
, pymongo
, pytestCheckHook
, pythonOlder
, ruamel-yaml
, setuptools
, setuptools-scm
, torch
, tqdm
}:

buildPythonPackage rec {
  pname = "monty";
  version = "2024.4.17";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "materialsvirtuallab";
    repo = "monty";
    rev = "refs/tags/v${version}";
    hash = "sha256-UqpRkw6F8RAvchq0HBSfdHHO8Lgg+yLdBku+wsPKg0E=";
  };

  postPatch = ''
    substituteInPlace tests/test_os.py \
      --replace 'self.assertEqual("/usr/bin/find", which("/usr/bin/find"))' '#'
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    msgpack
    ruamel-yaml
    tqdm
  ];

  nativeCheckInputs = [
    numpy
    pandas
    pydantic
    pymongo
    pytestCheckHook
    torch
  ];

  pythonImportsCheck = [
    "monty"
  ];

  disabledTests = [
    # Test file was removed and re-added after 2022.9.9
    "test_reverse_readfile_gz"
    "test_Path_objects"
    "test_zopen"
    "test_zpath"
  ];

  meta = with lib; {
    description = "Serves as a complement to the Python standard library by providing a suite of tools to solve many common problems";
    longDescription = "
      Monty implements supplementary useful functions for Python that are not part of the
      standard library. Examples include useful utilities like transparent support for zipped files, useful design
      patterns such as singleton and cached_class, and many more.
    ";
    homepage = "https://github.com/materialsvirtuallab/monty";
    changelog = "https://github.com/materialsvirtuallab/monty/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}

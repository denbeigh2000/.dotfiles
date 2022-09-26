{ pkgs, ... }:

with pkgs; let
  inherit (python310Packages) buildPythonApplication buildPythonPackage fetchPypi;

  schema-src = fetchurl {
    url = "https://raw.githubusercontent.com/buildkite/pipeline-schema/f37f0d436de78ff1529d06e9e4cdee8ea590a169/schema.json";
    sha256 = "sha256-PqQg3yliPiIobDibhhODlJ3yMZhI6DF4WK8NWtliz/Y=";
  };

  pybuildkite = buildPythonPackage rec {
    pname = "pybuildkite";
    version = "1.2.1";

    propagatedBuildInputs = with python310Packages; [ requests urllib3 ];

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-T7gpqarTnu+ojYXqQOKqV4WrT4E/gTfbXEMYLc5RxX4=";
    };
  };

  pypkgs = isDev: (p: with p;
    let
      reqPkgs = with p; [ click setuptools pybuildkite jsonschema ];
      devPkgs = with p; [
        pyls-isort
        pylsp-mypy
        python-lsp-black
        python-lsp-server
      ];

      maybeDevPkgs = if isDev then devPkgs else [ ];
    in
    reqPkgs ++ maybeDevPkgs);

  python = python310.withPackages (pypkgs false);
  pythonDev = python310.withPackages (pypkgs true);
in
{
  ci = buildPythonApplication {
    pname = "ci";
    version = "0.0.0";
    format = "pyproject";

    src = ./.;

    propagatedBuildInputs = pypkgs false python310Packages;
  };

  devShell = mkShell {
    name = "ci-dev-shell";
    buildInputs = [ pythonDev ];
    shellHook = ''
      PYTHONPATH=${python}/${python.sitePackages}
    '';
  };
}

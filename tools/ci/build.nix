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

  tool = buildPythonApplication {
    name = "ci-tools";
    format = "pyproject";

    src = ./.;

    # Idea of using meta.ci:
    #  - When CI pipelines change -> derivation changes -> is ran in CI
    #  - Derivation contains all data necessary to create subsequent CI tasks
    #
    # This will cause us to not be able to use `nix eval`/`nix check` - worth it?
    # meta.ci = {
    #   tagPrefix = "ci-tools";
    #
    #   # Each of these lists should contain derivations outputting a pipeline.yml file
    #   # Running builds + checks in pre-merge is implicit
    #   pre-merge = [ ]; # Actions to run at pre-merge time (building and running checks is implied)
    #   post-merge = [ ]; # Actions to run after merging to master
    #   tag = [ ]; # Actions to run when a new tag is made with the given tagPrefix
    # };

    propagatedBuildInputs = pypkgs false python310Packages;
  };

  devShell = mkShell {
    name = "ci-dev-shell";
    buildInputs = [ pythonDev ];
    shellHook = ''
      PYTHONPATH=${python}/${python.sitePackages}
    '';
  };

in
{
  ci = tool;
  inherit devShell;
}

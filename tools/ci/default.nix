{ pkgs, ... }:

with pkgs; let
  inherit (python310Packages) buildPythonApplication;

  pypkgs = isDev: (p: with p;
    let
      reqPkgs = with p; [ click setuptools ];
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
    buildInputs = [ pythonDev ];
    shellHook = ''
      PYTHONPATH=${python}/${python.sitePackages}
    '';
  };
}

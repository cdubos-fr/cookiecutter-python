# Centralized package management
{
  pkgs,
  python,
  pyproject,
  lib,
}:

let
  tox-pdm-project = pyproject.lib.project.loadPyproject {
    projectRoot = pkgs.fetchzip {
      url = "https://github.com/pdm-project/tox-pdm/archive/refs/tags/0.7.2.zip";
      hash = "sha256-JqIeJpAKTv2ruMx/fB16u7j+JJGQz7dwOEiNc/FGZLo=";
    };
  };
  tox-pdm-attrs = tox-pdm-project.renderers.buildPythonPackage { inherit python; };
  tox-pdm = python.pkgs.buildPythonPackage (tox-pdm-attrs // { version = "0.7.2"; });
  # Load overrides
  overrides = lib.safeImport ./overrides.nix { inherit pkgs; } { };

  # Basic development tools
  devTools = {
    inherit (pkgs) git just openssh;
    inherit (python.pkgs) virtualenv pip ipython;
  };

  # CI tools
  ciTools = {
    # To build nixfmt
    inherit (pkgs) cabal-install ghc nixfmt-rfc-style;
    inherit (pkgs) pre-commit ruff pdm;
    inherit (python.pkgs) tox;
    tox-pdm = tox-pdm;
  };

  # Tools that might be problematic
  optionalTools = builtins.mapAttrs (name: _: lib.tryPackage pkgs name) {
    # Known problematic packages
    inherit (pkgs) commitizen;
  };

  # Diagnostic tools
  diagnosticTool = pkgs.writeShellScriptBin "nix-diagnose" ''
    echo "Diagnosing Nix setup for a-simple-project-name..."
    echo "Python: ${python.name}"
    echo "System: ${pkgs.system}"

    echo -e "\nChecking required tools:"
    for cmd in git just pip virtualenv python tox; do
      if command -v $cmd >/dev/null 2>&1; then
        echo "✓ $cmd is available"
      else
        echo "✗ $cmd is not available"
      fi
    done
  '';

  # Merge all package sets and apply overrides
  allPackages = lib.mergePackages [
    devTools
    ciTools
    optionalTools
    { inherit diagnosticTool; }
    overrides # Apply overrides last
  ];
in
{
  # All development and CI packages as an attribute set
  all = allPackages;

  # Convert to list for use in mkShell
  asList = lib.packagesToList allPackages;

  # Individual package groups for selective use
  dev = lib.mergePackages [
    devTools
    ciTools
    { inherit diagnosticTool; }
  ];
  ci = lib.mergePackages [ ciTools ];
}

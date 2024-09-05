{ pkgs, python, ... }:
{
  # To build nixfmt
  inherit (pkgs) cabal-install ghc;

  # CI tools
  inherit (pkgs) ruff pre-commit commitizen;
  pythonPackages = (python.withPackages (ps: [ ps.tox ]));
}

{ pkgs, python, ... }:
{
  ci-packages = with pkgs; [
    # To build nixfmt
    cabal-install
    ghc

    # CI tools
    ruff
    pre-commit
    commitizen
    (python.withPackages (
      ps: with ps; [
        tox
      ]
    ))
  ];
}

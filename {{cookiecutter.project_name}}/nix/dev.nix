{ pkgs, python, ... }:
{
  dev-packages =
    with import ./ci.nix {
      pkgs = pkgs;
      python = python;
    };
    with pkgs;
    [
      ci-packages
      (python.withPackages (
        ps: with ps; [
          virtualenv
          pip
          ipython
        ]
      ))
      pdm
      just
      git
      openssh
    ];
}

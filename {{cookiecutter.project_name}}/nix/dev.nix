{
  pkgs,
  python,
  pyproject,
}:
{
  inherit (pkgs)
    just
    git
    openssh
    ;
  inherit (python.pkgs)
    virtualenv
    pip
    ipython
    ;
}
// import ./ci.nix {
  pkgs = pkgs;
  python = python;
  pyproject = pyproject;
}

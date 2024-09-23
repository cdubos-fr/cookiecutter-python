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
  pythonPackages = (
    python.withPackages (
      ps: with ps; [
        virtualenv
        pip
        ipython
      ]
    )
  );
}
// import ./ci.nix {
  pkgs = pkgs;
  python = python;
  pyproject = pyproject;

}

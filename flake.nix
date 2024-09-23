{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    pyproject-nix.url = "github:nix-community/pyproject.nix";
    pyproject-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      flake-parts,
      pyproject-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        { pkgs, system, ... }:
        let
          python = pkgs.python3;
          getAttrsValue = name: value: value;
        in
        {
          devShells =
            {
              default = pkgs.mkShell {
                name = "cookiecutter-dev-env";
                # The Nix packages provided in the environment
                packages = [
                  (python.withPackages (pp: [pp.cookiecutter]))
                  pkgs.just
                  pkgs.git
                ];
              };
            };
        };
    };
}

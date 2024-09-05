{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2405.630312.tar.gz";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  # Flake outputs
  outputs =
    inputs@{ nixpkgs, flake-parts, ... }:
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
          pythonPackages = pkgs.python{{cookiecutter.python_version.replace('.', '')}}Packages;
          python = pkgs.python{{cookiecutter.python_version.replace('.', '')}};
        in
        {
          packages.default = pythonPackages.buildPythonPackage rec {
            pname = "{{cookiecutter.project_name}}";
            pyproject = true;
            version = "0.1.0";
            src = ./.;
            nativeBuildInputs = with pythonPackages; [ flit ];
          };

          devShells = {
            default = pkgs.mkShell {
              # The Nix packages provided in the environment
              packages =
                with import ./nix/dev.nix {
                  pkgs = pkgs;
                  python = python;
                }; [
                  dev-packages
                ];
              shellHook = ''
                just devenv
                source .venv/bin/activate
              '';
            };

            ci = pkgs.mkShell {
              # The Nix packages provided in the environment
              packages =
                with import ./nix/ci.nix {
                  pkgs = pkgs;
                  python = python;
                }; [
                  ci-packages
                  python.withPackages (
                    ps: with ps; [
                      tox-gh
                    ]
                  )
                ];
            };
          };
        };
    };
}

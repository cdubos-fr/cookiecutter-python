{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
          getAttrsValue = name: value: value;
        in
        {
          packages.default = pythonPackages.buildPythonPackage rec {
            pname = "{{cookiecutter.project_name}}";
            pyproject = true;
            version = "0.1.0";
            src = ./.;
            nativeBuildInputs = with pythonPackages; [ flit ];
          };

          devShells =
            let
              dev-packages = import ./nix/dev.nix {
                pkgs = pkgs;
                python = python;
              };
            in
            {
              default = pkgs.mkShell {
                # The Nix packages provided in the environment
                packages = (pkgs.lib.attrsets.mapAttrsToList getAttrsValue dev-packages);
                shellHook = ''
                  just devenv
                  source .venv/bin/activate
                '';
              };

              ci =
                let
                  ci-packages = import ./nix/ci.nix {
                    pkgs = pkgs;
                    python = python;
                  };
                  tox-gh = pythonPackages.buildPythonPackage rec {
                    pname = "tox-gh";
                    version = "1.3.2";
                    format = "pyproject";
                    src = pkgs.fetchFromGitHub {
                      owner = "tox-dev";
                      repo = "tox-gh";
                      rev = "ea2191adcf8757d76dc4cee4039980859f39b01e";
                      sha256 = "sha256-uRNsTtc7Fr95fF1XvW/oz/qBQORpvCt/Lforpd6VZtk=";
                    };
                    nativeBuildInputs = with pythonPackages; [
                      hatchling
                      hatch-vcs
                    ];
                    propagatedBuildInputs = [ ci-packages.pythonPackages ];
                  };
                in
                pkgs.mkShell {
                  # The Nix packages provided in the environment
                  packages = (pkgs.lib.attrsets.mapAttrsToList getAttrsValue ci-packages) ++ [ tox-gh ];
                };
            };
        };
    };
}

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
          # Import utility functions
          lib = import ./nix/lib.nix;

          # Set up Python
          python = pkgs.python{{cookiecutter.python_version.replace('.', '')}};

          # Load all packages
          packages = import ./nix/packages.nix {
            pkgs = pkgs;
            python = python;
            pyproject = pyproject-nix;
            lib = lib;
          };

          # Build the Python package
          pythonPackage =
            let
              projectResult = builtins.tryEval (
                pyproject-nix.lib.project.loadPDMPyproject {
                  projectRoot = ./.;
                }
              );

              defaultPackage =
                if projectResult.success then
                  let
                    attrs = projectResult.value.renderers.buildPythonPackage { inherit python; };
                  in
                  python.pkgs.buildPythonPackage attrs
                else
                  pkgs.stdenv.mkDerivation {
                    name = "{{cookiecutter.project_name}}";
                    src = ./.;
                    phases = [ "installPhase" ];
                    installPhase = ''
                      mkdir -p $out/lib
                      cp -r $src/* $out/lib/
                      echo "Built with fallback method" > $out/lib/BUILD_INFO
                    '';
                  };
            in
            defaultPackage;
        in
        {
          # Default package is the Python package
          packages.default = pythonPackage;

          # Development shell with all tools
          devShells.default = pkgs.mkShell {
            name = "{{cookiecutter.project_name}}-dev-env";
            packages = packages.asList;
            shellHook = ''
              # Welcome message
              echo "Welcome to {{cookiecutter.project_name}} development environment"

              # Try to set up environment with just
              if command -v just >/dev/null 2>&1 && [ -f Justfile ]; then
                echo "* Run 'just' to see available commands"
              else
                echo "* 'just' command or Justfile not found"
              fi

              # Set up virtual environment if it doesn't exist
              if ! [ -d .venv ] && command -v virtualenv >/dev/null 2>&1; then
                echo "* Setting up Python virtual environment in .venv"
                just devenv
              fi

              # Activate virtual environment if it exists
              if [ -d .venv ] && [ -f .venv/bin/activate ]; then
                echo "* Activating Python virtual environment"
                source .venv/bin/activate
              fi
            '';
          };

          # CI shell with minimal tools
          devShells.ci = pkgs.mkShell {
            name = "{{cookiecutter.project_name}}-ci";
            packages = lib.packagesToList packages.ci;
          };
        };
    };
}

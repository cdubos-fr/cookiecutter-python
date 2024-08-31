{
    inputs = {
        nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2405.630312.tar.gz";
    };

    # Flake outputs
    outputs = { self, nixpkgs }:
        let
        # Systems supported
        allSystems = [
            "x86_64-linux" # 64-bit Intel/AMD Linux
            "aarch64-linux" # 64-bit ARM Linux
            "x86_64-darwin" # 64-bit Intel macOS
            "aarch64-darwin" # 64-bit ARM macOS
        ];

        # Helper to provide system-specific attributes
        forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
            pkgs = import nixpkgs { inherit system; };
        });
        in
        {
            # Development environment output
            devShells = forAllSystems ({ pkgs }: {
                default =
                let
                    python = pkgs.python{{cookiecutter.python_version.replace('.', '')}};
                in
                pkgs.mkShell {
                    # The Nix packages provided in the environment
                    packages = with pkgs; [
                        # Python plus helper tools
                        (python.withPackages (ps: with ps; [
                            virtualenv
                            pip
                            tox
                            pdm
                        ]))
                        just
                        git
                        pre-commit
                        openssh
                        # To build ruff
                        rustc
                        cargo
                    ];
                    shellHook = ''
                        export PIP_NO_BINARY="ruff"
                        just devenv
                        source .venv/bin/activate
                    '';
                };
            });
        };
}

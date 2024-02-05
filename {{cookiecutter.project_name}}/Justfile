set shell := ["zsh", "-uc"]

devenv:
    tox devenv -e devenv .venv
    pre-commit install

serve-docs:
    mkdocs serve

clear:
    rm -r .venv
    rm -r .ruff_cache
    rm -r .tox
    rm -r .vagrant

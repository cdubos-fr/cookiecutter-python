[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)
[![Ruff](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/ruff/main/assets/badge/v2.json)](https://github.com/astral-sh/ruff)
[![security: bandit](https://img.shields.io/badge/security-bandit-yellow.svg)](https://github.com/PyCQA/bandit)
[![Checked with mypy](https://www.mypy-lang.org/static/mypy_badge.svg)](https://mypy-lang.org/)

{{cookiecutter.description}}

# Installation

```bash
$ pip install <path-to-this-project>
```
or
```bash
$ pip install git+<git-url>
```

to install it in editable mode:
```bash
$ pip install -e .
```

to add developpement dependencies:
```bash
$ pip install -e ".[dev]"
```

and use pre-commit to check your code
```bash
$ pre-commit install
```

# Setup environnement de dev'

```shell
just devenv
```

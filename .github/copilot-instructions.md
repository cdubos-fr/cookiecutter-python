# Instructions pour les agents IA sur ce projet cookiecutter-python

## Vue d'ensemble
Template Cookiecutter pour projets Python simples (sans Nix) avec : packaging Flit, tox + tox-uv, virtualenv, dependency-groups (PDM style), lint/format (Ruff), types (mypy), tests (pytest+cov), docs (MkDocs) et automatisations via Justfile.

## Structure principale
- `{{cookiecutter.project_name}}/` : Racine du projet généré
  - `{{cookiecutter.project_slug}}.py` (si module fichier) / sinon package dans `{{cookiecutter.project_slug}}/`
  - `{{cookiecutter.project_slug}}/` : Code source + `__init__.py` contenant `__version__`
  - `docs/` : Contenu MkDocs (`index.md` minimal)
  - `tests/` : Tests pytest (ex: `test_packaging_attribute.py` vérifie PEP 440 & description)
  - Fichiers config : `pyproject.toml`, `tox.ini`, `Justfile`, `mkdocs.yml`
- `hooks/` : Scripts Cookiecutter post-génération

## Workflows critiques
- Environnement de dev : `just devenv` crée `.venv` via `uv venv`, installe `.[dev,typing,tests,docs,security]` via `uv pip`, active pre-commit.
- Tests rapides : `pytest` ou `tox -e tests` (couverture avec seuil 80% + `--cov-report=term-missing`).
- Lint/format : `pre-commit run ruff --all-files` et `pre-commit run ruff-format --all-files` (Ruff gère import, style et docstrings; ignore pydocstyle dans `tests/`).
- Typage : `tox -e typing` (exécute mypy sur package + tests, options strictes via override dans `[tool.mypy]`).
- Docs : `tox -e docs` ou `mkdocs build`. `serve` local : `just serve-docs`.
- Release (semver) : `cz bump` (Commitizen met à jour version dans `pyproject.toml` + `__init__.py`).
- Build artefacts : `python -m build` (sdist+wheel) ou `just build`.
- Vérification globale CI locale : `just check` (alias `tox`).

## Conventions spécifiques
- Regroupement des dépendances via `[dependency-groups]` : `dev`, `typing`, `tests`, `docs`, `security` (consommés par tox-uv via `dependency_groups =`).
- `tox` + `tox-uv` synchronisent les groupes (ex: `[testenv:typing]` déclare `dependency_groups = typing`).
- `__version__` exposé dans le package pour tests PEP 440 (`test_packaging_attribute.py`).
- Ruff configuré avec sélections multiples (E,F,W,C90,I,N,D,UP,B,ANN,...) et ignore ciblé (`ANN101`, docstring style). Tests exclus des règles doc & `S101`.
- Mypy : mode strict appliqué aux modules du package (overrides) avec `disallow_untyped_defs` etc.
- Pas de Nix : ne pas réintroduire de dépendances spécifiques (remplacé par virtualenv + tox-uv).
- Utiliser `.venv` local activé explicitement (pas de gestion automatique).

## Points d'intégration
- Tox = orchestrateur (tests / typing / docs / precommit).
- Pre-commit = exécution standardisée de Ruff & format; installer après `just devenv`.
- Commitizen = bump version cohérent + changelog (si configuré ultérieurement).
- MkDocs = docs statiques (aucune config avancée ici, base extensible).

## Exemples de commandes utiles
- Init env : `just devenv` (ou manuel: `uv venv .venv && source .venv/bin/activate && uv pip install -e .[dev,typing,tests,docs,security]`). Alternative pip: `python -m venv .venv && source .venv/bin/activate && pip install -e .[dev,typing,tests,docs,security]`.
- Tests : `pytest -q` / `tox -e tests`
- Couverture détaillée : `pytest --cov={{cookiecutter.project_slug}} --cov-report=term-missing`
- Lint : `pre-commit run ruff --all-files`
- Format : `pre-commit run ruff-format --all-files`
- Typage : `tox -e typing` ou `mypy -p {{cookiecutter.project_slug}}`
- Docs build : `mkdocs build` ; serveur : `mkdocs serve`
- Release : `cz bump`

## Fichiers clés à consulter
- `pyproject.toml` : metadata + dependency-groups + config outils (ruff, mypy, commitizen)
- `tox.ini` : mapping environnements -> dependency_groups (tests, typing, docs, security, precommit, devenv)
- `Justfile` : automatisations (env, test, build, release)
- `tests/test_packaging_attribute.py` : conventions de version et docstring
- `hooks/post_gen_project.py` : ajustements post-génération Cookiecutter
- `mkdocs.yml` + `docs/` : base docs

---

Adaptez les suggestions aux conventions établies (dependency-groups, tox-uv, pre-commit). En cas de nouvelle dépendance, décider si elle va dans `dependencies` (runtime) ou un groupe (`dev`/`typing`/`tests`/`docs`). Garder cohérence Ruff/mypy. Signaler toute régression de couverture (<80%).

Note commits: suivez Conventional Commits (feat, fix, chore, ci, docs, refactor, test, build, etc.). Commitizen est configuré pour guider la rédaction et la gestion de version (`cz bump`).

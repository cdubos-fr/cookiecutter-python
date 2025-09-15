# Instructions pour les agents IA sur ce projet

## Vue d'ensemble
Projet Python packagé avec Flit, orchestré par tox + tox-uv, environnement local en `.venv` via `tox --devenv`, qualité via Ruff (lint/format), mypy (types), pytest (tests+cov), docs MkDocs, automatisations via Justfile et pre-commit.

## Workflows essentiels
- Environnement de dev: `just devenv` crée/synchronise `.venv` via `tox --devenv -e devenv` (tox-uv lit `[dependency-groups]`) et installe les hooks pre-commit.
- Tests: `tox -e tests` (couverture 80% mini, rapport manquant en terminal).
- Typage: `tox -e typing` (mypy sur package + tests en mode strict configuré dans `pyproject.toml`).
- Lint/format: `pre-commit run ruff --all-files` et `pre-commit run ruff-format --all-files`.
- Docs: `tox -e docs` pour build, `just serve-docs` pour servir en local.
- Sécurité: `tox -e security` (bandit + safety, en best-effort).

## Logique de travail et outils
- Création et activation de l’environnement Python via `.envrc` et `direnv` (automatisation locale)
- Utilisation de la commande `just devenv` pour initialiser et installer l’environnement de développement (dépendances, activation, etc.)
- Utilisation de meta-commandes dans le `Justfile` pour centraliser les tâches courantes (build, test, lint, etc.)
- Management centralisé des tests et de la création d’environnement avec `tox` (multi-environnements, CI)
- Gestion des dépendances avec `uv` (rapide, moderne, compatible PEP)
- Packaging et distribution avec `flit`

## Dépendances
- Dépendances runtime: `[project.dependencies]`.
- Groupes de dev via `[dependency-groups]`: `dev`, `typing`, `tests`, `docs`, `security`.
- Tox-uv synchronise les groupes pour chaque env (`dependency_groups = ...` dans `tox.ini`).

## Commandes utiles
- Dev env: `just devenv` (recommandé) ou manuel: `python -m venv .venv && source .venv/bin/activate && pip install -e .[dev,typing,tests,docs,security]`.
- Lancer tous les checks: `just check` (alias `tox`).
- Nettoyage: `just clean`.
- Release (semver): `cz bump` (met à jour la version dans `pyproject.toml` + `__init__.py`).

## Fichiers clés
- `pyproject.toml`: metadata + dependency-groups + config outils (ruff, mypy, commitizen).
- `tox.ini`: environnements tox mappés vers `dependency_groups` (tests, typing, precommit, docs, security, devenv).
- `Justfile`: recettes dev (env, tests, types, lint/format, docs, build, release).
- `tests/test_packaging_attribute.py`: vérifie `__version__` (PEP 440) et description.
- `mkdocs.yml` et `docs/`.

Adaptez les suggestions aux conventions établies (dependency-groups, tox-uv, pre-commit). Conservez la cohérence Ruff/mypy et évitez les régressions de couverture (<80%).

Note commits: utiliser le format Conventional Commits (feat, fix, chore, ci, docs, refactor, test, build, etc.). Commitizen est configuré (`cz bump`, hook commit disponible) pour guider et gérer le versioning sémantique.

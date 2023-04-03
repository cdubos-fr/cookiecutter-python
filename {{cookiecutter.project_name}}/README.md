{{cookiecutter.description}}

# Installation
{% if cookiecutter.is_installable.lower() == 'false' -%}
```bash
$ pip install -r requirements.txt
```
{% else %}
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
{%- endif %}

to add developpement dependencies:
```bash
$ pip install -r requirements-dev.txt
```

and use pre-commit to check your code
```bash
$ pre-commit install
```

# Setup environnement de dev'

- `$ tox devenv -e devenv`
- `pre-commit install`

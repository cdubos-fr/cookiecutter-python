
'''
{% if (cookiecutter.is_file_module | string ).lower() in ("true", "yes", "1", "y") or cookiecutter.is_file_module == true %}
{{cookiecutter.update({"is_file_module": true })}}
{% else %}
{{cookiecutter.update({"is_file_module": false })}}
{% endif %}
'''

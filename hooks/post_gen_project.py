#!/usr/bin/env python
import os
import shutil
import pathlib

CURRENT_PATH = pathlib.Path(os.getcwd())


def clear_folder_module():
    shutil.rmtree(CURRENT_PATH / '{{cookiecutter.project_slug}}')


def clear_file_module():
    os.remove(CURRENT_PATH / '{{cookiecutter.project_slug}}.py')


if __name__ == "__main__":
    if {{cookiecutter.is_file_module}}:
        clear_folder_module()
    else:
        clear_file_module()
    os.system(f"git init {CURRENT_PATH}")
    os.system(f"git add {CURRENT_PATH}/*")

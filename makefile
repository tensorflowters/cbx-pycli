PYENV_VERSION := 3.12.1

pyenv_list:
	@pyenv install -l

pyenv_install_python:
	@pyenv install ${PYENV_VERSION}

pyenv_list_installed:
	@pyenv versions

pyenv_uninstall_python:
	@pyenv uninstall ${PYENV_VERSION}

pyenv_local_install_python:
	@pyenv local ${PYENV_VERSION}

pyenv_global_install_python:
	@pyenv global ${PYENV_VERSION}

pyenv_system_install_python:
	@pyenv system ${PYENV_VERSION}

py_exec:
	@pyenv exec python --version


POETRY_ENV_PATH := $(poetry env info --path)
PYTHON_ENV_PATH := $(poetry env info --executable)


poe_path_list:
	@poetry env list --full-path

py_list_full_path:
	@poetry env info --executable

poe_activate:
	@poetry shell

poe_install:
	@poetry install

poe_update:
	@poetry update

poe_add: lib =?
poe_add:
	@poetry add ${lib}

poe_rm: lib =?
poe_rm:
	@poetry remove ${lib}

poe_add_dev: lib =?
poe_add_dev:
	@poetry add ${lib} --group dev

poe_build:
	@poetry build -o usr/bin/cbx-cli --format stdist

include .env
export $(shell sed 's/=.*//' .env)

SYSTEM_SHELL := $(shell echo $$SHELL)


pyenv_list:
	@pyenv install -l

pyenv_list_installed:
	@pyenv versions

pyenv_uninstall_python:
	@pyenv global ${PY_ENV_LOCAL}

pyenv_install_python:
	@pyenv install ${PY_ENV_LOCAL}

pyenv_local_install_python:
	@pyenv local ${PY_ENV_LOCAL}

pyenv_global_install_python:
	@pyenv global ${PY_ENV_LOCAL}

pyenv_system_install_python:
	@pyenv system ${PY_ENV_LOCAL}


py_exec:
	@pyenv exec python --version


POETRY_ENV_PATH := $(poetry env info --path)
PYTHON_ENV_PATH := $(poetry env info --executable)

ifeq ($(POETRY_ENV_PATH),)
poe_path:
	@echo "Poetry environment path is not set."
else
poe_path:
	@echo "Poetry environment path is set to: $(POETRY_ENV_PATH)"
endif


ifeq ($(PYTHON_ENV_PATH),)
poe_executable:
	@echo "Python executable path is not set."
else
poe_executable:
	@echo "Python executable path is set to: $(PYTHON_ENV_PATH)"
endif

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
	@poetry build

local_install:
	@pipx install --user /home/athernatos/workspace/cyb-devtools/cbx-pycli/dist/cbx_pycli-0.1.0-py3-none-any.whl

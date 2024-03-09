include .env
export $(shell sed 's/=.*//' .env)

SYSTEM_SHELL := $(shell echo $$SHELL)

sys_install:
	@sudo apt-get update
	@sudo apt-get install -y jq git curl

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

pyenv_shell:
	@pyenv shell ${PY_SHELL}

pyenv_local:
	@pyenv local ${PY_ENV_LOCAL}

pyenv_global:
	@pyenv local ${PY_ENV_GLOBAL}

# A special version name "system" means to use whatever Python is found on PATH
pyenv_system:
	@pyenv system


# Displays which real executable would be run when you invoke <command> via a shim.
pyenv_which: command =?
pyenv_which:
	@pyenv which ${command}
